# gf-nginx-on-vagrant
For Girlfriend to Study Nginx


# Start the Box

```bash
vagrant up

```

# Visit the Services behind Nginx

## after vagrant fully up
visit -> http://localhost:8080/

It will blance work load to all the underlying services on (8081~8085) using default load-balancing algo from NGINX.

If you try to kill one of the services, you will see the difference.
E.g. kill service instance 01 by http://localhost:8081/exit and then refresh the page http://localhost:8080/
