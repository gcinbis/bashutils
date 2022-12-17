Matplotlib notes
================

## Plotting and pausing until key/button press

Call the following function after creating & plotting the figures:
```python
import matplotlib.pyplot as plt
def plt_show(press_q_to_exit=True,close_window_to_exit=True,ignore_clicks=False):
    '''
    A utility function to simplify displaying figures and waiting for interaction.
    Catches key-press/button-press/window-close interactions across all matplotlib figures, 
    and returns simplified event information. Additionally provides shortcuts for easier use.

    ARGUMENTS
    press_q_to_exit         End the process when 'q' is pressed. (default=True) 
    close_window_to_exit    End the process whenever a window is closed. (default=True)
    ignore_clicks           Keep waiting in the case of mouse clicks. (default=False)

    RETURN VALUE
    A dictionary with the following keys:
    ['type']                A string: key_press | button_press | window_close | other
    ['key']                 The key pressed (Available only if key_press)
    ['button']              The mouse button (Available only if button_press)
    '''
    event_info = {}
    event_info['type'] = 'other'
    active_fig_number = plt.gcf().number
    def onkeypress(event):
        event_info['type'] = 'key_press'
        event_info['key'] = event.key 
    def onclick(event):
        event_info['type'] = 'button_press'
        event_info['button'] = event.button 
    def onclose(event):
        event_info['type'] = 'window_close'
    for fi in plt.get_fignums(): # bing event handlers to all figures
        plt.figure(fi)
        plt.ion()
        plt.show(block=False)
        plt.gcf().canvas.mpl_connect('key_press_event', lambda e: onkeypress(e))
        plt.gcf().canvas.mpl_connect('button_press_event', onclick)
        plt.gcf().canvas.mpl_connect('close_event', onclose)
    plt.figure(active_fig_number) # reactive the originally active figure
    if ignore_clicks:
        while not plt.waitforbuttonpress(): pass 
    else:
        plt.waitforbuttonpress() 
    if press_q_to_exit and event_info['type']=='key_press' and event_info['key'] in ['q','Q']:
        exit(0)
    elif close_window_to_exit and event_info['type']=='window_close':
        exit(0)
    return event_info
```


