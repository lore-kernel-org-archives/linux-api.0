From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 4/4] samples: Add example of using PTRACE_GETFD in
 conjunction with user trap
Date: Mon, 9 Dec 2019 20:30:00 +0100
Message-ID: <20191209192959.GB10721@redhat.com>
References: <20191209070646.GA32477@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191209070646.GA32477@ircssh-2.c.rugged-nimbus-611.internal>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, luto@amacapital.net, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 12/09, Sargun Dhillon wrote:
>
> +#define CHILD_PORT_TRY_BIND=0980
> +#define CHILD_PORT_ACTUAL_BIND=094998

...

> +static int handle_req(int listener)
> +{
> +=09struct sockaddr_in addr =3D {
> +=09=09.sin_family=09=3D AF_INET,
> +=09=09.sin_port=09=3D htons(4998),

then I think
=09=09.sin_port =3D htons(CHILD_PORT_ACTUAL_BIND);

would be more clear...

> +=09=09.sin_addr=09=3D {
> +=09=09=09.s_addr=09=3D htonl(INADDR_LOOPBACK)
> +=09=09}
> +=09};
> +=09struct ptrace_getfd_args getfd_args =3D {
> +=09=09.options =3D PTRACE_GETFD_O_CLOEXEC
> +=09};
> +=09struct seccomp_notif_sizes sizes;
> +=09struct seccomp_notif_resp *resp;
> +=09struct seccomp_notif *req;
> +=09int fd, ret =3D 1;
> +
> +=09if (seccomp(SECCOMP_GET_NOTIF_SIZES, 0, &sizes) < 0) {
> +=09=09perror("seccomp(GET_NOTIF_SIZES)");
> +=09=09goto out;
> +=09}
> +=09req =3D malloc(sizes.seccomp_notif);
> +=09if (!req)
> +=09=09goto out;
> +=09memset(req, 0, sizeof(*req));
> +
> +=09resp =3D malloc(sizes.seccomp_notif_resp);
> +=09if (!resp)
> +=09=09goto out_free_req;
> +=09memset(resp, 0, sizeof(*resp));
> +
> +=09if (ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, req)) {
> +=09=09perror("ioctl recv");
> +=09=09goto out;
> +=09}
> +=09printf("Child tried to call bind with fd: %lld\n", req->data.args[0])=
;
> +=09getfd_args.fd =3D req->data.args[0];
> +=09fd =3D ptrace_getfd(req->pid, &getfd_args);

and iiuc otherwise you do not need to ptrace the child. So you could remove
ptrace(PTRACE_SEIZE) in main() and just do

=09ptrace(PTRACE_SEIZE, req->pid);
=09fd =3D ptrace_getfd(req->pid, &getfd_args);
=09ptrace(PTRACE_DETACH, req->pid);

here. However, PTRACE_DETACH won't work, it needs the stopped tracee. We ca=
n
add PTRACE_DETACH_ASYNC, but this makes me think that PTRACE_GETFD has noth=
ing
to do with ptrace.

May be a new syscall which does ptrace_may_access() + get_task_file() will =
make
more sense?

Oleg.
