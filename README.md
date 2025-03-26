IDOR-Auto

IDOR-Auto is a command-line tool that automates the process of finding Insecure Direct Object Reference (IDOR) vulnerabilities in web applications. The tool is designed for bug bounty hunters and penetration testers who want to identify IDOR vulnerabilities in their target web applications.


Features
Automated IDOR detection using a custom wordlist
Supports multiple HTTP methods (GET, POST, PUT, DELETE)
Interactive mode for easy configuration
Option to save results to a file
Lightweight and easy to use

Installation
To install IDOR Hunter, you can use the following commands:
```bash
git clone https://github.com/SKHTW/IDOR-Auto.git
```
```bash
cd IDOR-Auto
```
```bash
chmod +x IDOR-Auto.sh
```

Usage

To start IDOR Hunter, run the following command:
```bash
./IDOR-Auto.sh
```

You will be prompted to enter the URL of the target web application, a custom wordlist, and the HTTP method to use for the request. You can also choose to save the results to a file.

Once the scan is complete, IDOR Hunter will output a list of potential IDOR vulnerabilities found in the target web application.

Contributing

If you find a bug or want to contribute to the project, you can do so by submitting a pull request or opening an issue on the project's GitHub page.

License

IDOR-Auto is licensed under the MIT license. See the LICENSE file for more information.
