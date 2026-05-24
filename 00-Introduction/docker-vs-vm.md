# Docker Containers vs Virtual Machines

| Feature        | Virtual Machine     | Docker Container      |
| -------------- | ------------------- | --------------------- |
| OS             | Runs own guest OS   | Shares host OS kernel |
| Boot time      | Minutes             | Seconds               |
| Size           | GBs                 | MBs                   |
| Performance    | Slower (hypervisor) | Near native           |
| Isolation      | Full                | Process level (less)  |
| Resource usage | More                | Less                  |

**When to use VMs:** Strong isolation, run multiple different OS types.  
**When to use containers:** Microservices, scalable apps, CI/CD, consistent environments.

> 📘 Next: [Ecosystem Overview](ecosystem-overview.md)
