# F6 toggles ipdb debug breakpoint
# Reference: https://gist.github.com/berinhard/523420/89ce9864ce60b9053b31c8a26a20ae0355892f3b
import vim
import re
ipdb_breakpoint = 'import ipdb; ipdb.set_trace()'
def set_breakpoint():
    breakpoint_line = int(vim.eval('line(".")')) - 1
    current_line = vim.current.line
    # invalid char: white_spaces = re.search('^(\s*)', current_line).group(1)
    white_spaces = re.search(r'^(\s*)', current_line).group(1)
    vim.current.buffer.append(white_spaces + ipdb_breakpoint, breakpoint_line)
def remove_breakpoints():
    op = 'g/^.*%s.*/d' % ipdb_breakpoint
    vim.command(op)
def toggle_breakpoint():
    breakpoint_line = int(vim.eval('line(".")')) - 1
    if 'import ipdb; ipdb.set_trace()' in vim.current.buffer[breakpoint_line]:
        remove_breakpoints()
    elif 'import ipdb; ipdb.set_trace()' in vim.current.buffer[breakpoint_line-1]:
        remove_breakpoints()
    else :
        set_breakpoint()
    vim.command(':w')
#vim.command('map <f6> :py toggle_breakpoint()<cr>')
