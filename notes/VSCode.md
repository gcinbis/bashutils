VSCode basics
=============

## Running a Makefile 

* Within the root of the project, create `.vscode/tasks.json` with the following content:

```
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "make",
            "type": "shell",
            "command": "make",
            "problemMatcher": [],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```

* Run vscode within the project root (`code .`), and press ctrl+shift+B


