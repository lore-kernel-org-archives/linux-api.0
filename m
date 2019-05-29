From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V6 04/10] audit: log container info of syscalls
Date: Wed, 29 May 2019 18:15:30 -0400
Message-ID: <CAHC9VhRfQp-avV2rcEOvLCAXEz-MDZMp91UxU+BtvPkvWny9fQ@mail.gmail.com>
References: <cover.1554732921.git.rgb@redhat.com> <f4a49f7c949e5df80c339a3fe5c4c2303b12bf23.1554732921.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <f4a49f7c949e5df80c339a3fe5c4c2303b12bf23.1554732921.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On Mon, Apr 8, 2019 at 11:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Create a new audit record AUDIT_CONTAINER_ID to document the audit
> container identifier of a process if it is present.
>
> Called from audit_log_exit(), syscalls are covered.
>
> A sample raw event:
> type=3DSYSCALL msg=3Daudit(1519924845.499:257): arch=3Dc000003e syscall=
=3D257 success=3Dyes exit=3D3 a0=3Dffffff9c a1=3D56374e1cef30 a2=3D241 a3=
=3D1b6 items=3D2 ppid=3D606 pid=3D635 auid=3D0 uid=3D0 gid=3D0 euid=3D0 sui=
d=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D3 comm=3D"bash=
" exe=3D"/usr/bin/bash" subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0=
:c0.c1023 key=3D"tmpcontainerid"
> type=3DCWD msg=3Daudit(1519924845.499:257): cwd=3D"/root"
> type=3DPATH msg=3Daudit(1519924845.499:257): item=3D0 name=3D"/tmp/" inod=
e=3D13863 dev=3D00:27 mode=3D041777 ouid=3D0 ogid=3D0 rdev=3D00:00 obj=3Dsy=
stem_u:object_r:tmp_t:s0 nametype=3D PARENT cap_fp=3D0 cap_fi=3D0 cap_fe=3D=
0 cap_fver=3D0
> type=3DPATH msg=3Daudit(1519924845.499:257): item=3D1 name=3D"/tmp/tmpcon=
tainerid" inode=3D17729 dev=3D00:27 mode=3D0100644 ouid=3D0 ogid=3D0 rdev=
=3D00:00 obj=3Dunconfined_u:object_r:user_tmp_t:s0 nametype=3DCREATE cap_fp=
=3D0 cap_fi=3D0 cap_fe=3D0 cap_fver=3D0
> type=3DPROCTITLE msg=3Daudit(1519924845.499:257): proctitle=3D62617368002=
D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E746169=
6E65726964
> type=3DCONTAINER_ID msg=3Daudit(1519924845.499:257): contid=3D123458
>
> Please see the github audit kernel issue for the main feature:
>   https://github.com/linux-audit/audit-kernel/issues/90
> Please see the github audit userspace issue for supporting additions:
>   https://github.com/linux-audit/audit-userspace/issues/51
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Steve Grubb <sgrubb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h      |  5 +++++
>  include/uapi/linux/audit.h |  1 +
>  kernel/audit.c             | 20 ++++++++++++++++++++
>  kernel/auditsc.c           | 20 ++++++++++++++------
>  4 files changed, 40 insertions(+), 6 deletions(-)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 182b0f2c183d..3e0af53f3c4d 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2127,6 +2127,26 @@ void audit_log_session_info(struct audit_buffer *a=
b)
>         audit_log_format(ab, "auid=3D%u ses=3D%u", auid, sessionid);
>  }
>
> +/*
> + * audit_log_contid - report container info
> + * @context: task or local context for record
> + * @contid: container ID to report
> + */
> +void audit_log_contid(struct audit_context *context, u64 contid)
> +{
> +       struct audit_buffer *ab;
> +
> +       if (!audit_contid_valid(contid))
> +               return;
> +       /* Generate AUDIT_CONTAINER_ID record with container ID */
> +       ab =3D audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
> +       if (!ab)
> +               return;
> +       audit_log_format(ab, "contid=3D%llu", (unsigned long long)contid)=
;

We have a consistency problem regarding how to output the u64 contid
values; this function uses an explicit cast, others do not.  According
to Documentation/core-api/printk-formats.rst the recommendation for
u64 is %llu (or %llx, if you want hex).  Looking quickly through the
printk code this appears to still be correct.  I suggest we get rid of
the cast (like it was in v5).

> +       audit_log_end(ab);
> +}
> +EXPORT_SYMBOL(audit_log_contid);
