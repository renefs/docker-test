FROM centos/python-34-centos7

EXPOSE 8080

# Install yum packages with the ROOT user
USER root
#RUN yum install -y epel-release
#RUN yum install -y python3-devel

ENV LD_LIBRARY_PATH /opt/rh/rh-python34/root/usr/lib64:/opt/rh/httpd24/root/usr/lib64
ENV PYTHONPATH /opt/app-root
ENV FLASK_APP /opt/app-root/app/main.py

# Make sure we can execute the entrypoint
COPY ./etc /opt/app-root/etc
RUN chmod ug+x /opt/app-root/etc/entrypoint.sh

# Set the permissions for the app-user user
RUN chgrp -R 0 /opt/app-root && chmod -R ug+rwx /opt/app-root

USER 1001

WORKDIR /opt/app-root

RUN pip install --upgrade pip
# Install uwsgi Python web server
RUN pip install uwsgi
# Install pip requirements
COPY requirements.txt /opt/app-root/requirements.txt
RUN pip install -r requirements.txt
# Copy the application files
COPY ./app /opt/app-root/app

CMD ["uwsgi", "--ini", "/opt/app-root/etc/uwsgi.ini"]
#ENTRYPOINT ["python", "app/main.py"]
#ENTRYPOINT ["/opt/app-root/etc/entrypoint.sh"]
