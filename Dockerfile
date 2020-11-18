FROM centos

RUN yum install -y java-1.8.0-openjdk.x86_64

ARG SBT_VERSION=1.3.13

EXPOSE 9000

ADD target target

ENTRYPOINT ["target/universal/stage/bin/ecs-fargate-cloudservices-poc -Dplay.http.secret.key='QCY?tAnfk?aZ?iwrNwnxIlR6CTf:G3gf:90Latabg@5241AB`R5W:1uDFN];Ik@n'"]