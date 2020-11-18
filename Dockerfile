FROM centos

RUN yum install -y java-1.8.0-openjdk.x86_64

ARG SBT_VERSION=1.3.13

EXPOSE 9000

ADD target target

ENTRYPOINT ["target/universal/stage/bin/ecs-fargate-cloudservices-poc"]