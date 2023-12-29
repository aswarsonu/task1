# internsctl

The **internsctl** Linux command, developed in Bash script, offers a comprehensive set of functionalities for system operations. 

## Features

- **Manual Page:** Detailed documentation is available through the manual page. Execute `man internsctl` for more information.

- **--help Option:** Use the `internsctl --help` command to get usage examples and understand various use cases.

- **--version Option:** Execute `internsctl --version` to display the current command version (v0.1.0).

- **Functionality:**
  - **CPU Information:** Retrieve CPU information with `internsctl cpu getinfo`.
  - **Memory Information:** Get memory details using `internsctl memory getinfo`.
  - **User Management:**
    - Create a new user: `internsctl user create <username>`.
    - List regular users: `internsctl user list`.
    - List users with sudo permissions: `internsctl user list --sudo-only`.
  - **File Information:**
    - Obtain detailed information about a file: `internsctl file getinfo <file-name>`.
      - Options:
        - `--size` or `-s`: Print file size.
        - `--permissions` or `-p`: Print file permissions.
        - `--owner` or `-o`: Print file owner.
        - `--last-modified` or `-m`: Print last modified time.

## Best Practices

This project adheres to best practices, with code and configurations securely stored in a private Git repository.

## Usage

To use the internsctl command, follow the instructions in the [Installation](#installation) section.

## Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/internsctl.git
