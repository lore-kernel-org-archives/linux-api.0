From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
Date: Tue, 9 Apr 2019 09:46:19 -0400
Message-ID: <20190409134619.GA15660@hmswarspite.think-freely.org>
References: <cover.1554732921.git.rgb@redhat.com>
 <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, Steve Grubb <sgrubb@redhat.com>, David Howells <dhowells@redhat.com>, Simo Sorce <simo@redhat.com>, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 09, 2019 at 02:57:50PM +0200, Ondrej Mosnacek wrote:
> On Tue, Apr 9, 2019 at 5:40 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Add audit container identifier support to the action of signalling the
> > audit daemon.
> >
> > Since this would need to add an element to the audit_sig_info struct,
> > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > audit_sig_info2 struct.  Corresponding support is required in the
> > userspace code to reflect the new record request and reply type.
> > An older userspace won't break since it won't know to request this
> > record type.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> 
> This looks good to me.
> 
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> 
> Although I'm wondering if we shouldn't try to future-proof the
> AUDIT_SIGNAL_INFO2 format somehow, so that we don't need to add
> another AUDIT_SIGNAL_INFO3 when the need arises to add yet-another
> identifier to it... The simplest solution I can come up with is to add
> a "version" field at the beginning (set to 2 initially), then v<N>_len
> at the beginning of data for version <N>. But maybe this is too
> complicated for too little gain...
> 
So, I'm not sure how often this needs to be revised (if its not often, this may
be just fine), but if future proofing is warranted, it might be worthwhile to
just use the netlink TLV encoding thats available today.  The kernel has a suite
of nla_put_<type> macros (like nla_put_u32()), and the userspace netlink library
can parse those messages fairly easily.  It would let you send arbitrary length
messages with a terminator type at the end of the array.

That said, I don't think we want to do that right now for just this message.  A
better approach would be to do this now, and in a subsequent patch, create an
AUDIT version 2 netlink protocol that converts all the messages we send to that
format for consistency.  Such a change would be large and warrant its own patch
set and review.

I'm good with this patch as it is

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> > ---
> >  include/linux/audit.h       |  7 +++++++
> >  include/uapi/linux/audit.h  |  1 +
> >  kernel/audit.c              | 27 +++++++++++++++++++++++++++
> >  kernel/audit.h              |  1 +
> >  kernel/auditsc.c            |  1 +
> >  security/selinux/nlmsgtab.c |  1 +
> >  6 files changed, 38 insertions(+)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 43438192ca2a..c2dec9157463 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -37,6 +37,13 @@ struct audit_sig_info {
> >         char            ctx[0];
> >  };
> >
> > +struct audit_sig_info2 {
> > +       uid_t           uid;
> > +       pid_t           pid;
> > +       u64             cid;
> > +       char            ctx[0];
> > +};
> > +
> >  struct audit_buffer;
> >  struct audit_context;
> >  struct inode;
> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index 55fde9970762..10cc67926cf1 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -72,6 +72,7 @@
> >  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
> >  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
> >  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and info */
> > +#define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sender */
> >
> >  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
> >  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 3e0af53f3c4d..87e1d367f98c 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -138,6 +138,7 @@ struct audit_net {
> >  kuid_t         audit_sig_uid = INVALID_UID;
> >  pid_t          audit_sig_pid = -1;
> >  u32            audit_sig_sid = 0;
> > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> >
> >  /* Records can be lost in several ways:
> >     0) [suppressed in audit_alloc]
> > @@ -1097,6 +1098,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
> >         case AUDIT_ADD_RULE:
> >         case AUDIT_DEL_RULE:
> >         case AUDIT_SIGNAL_INFO:
> > +       case AUDIT_SIGNAL_INFO2:
> >         case AUDIT_TTY_GET:
> >         case AUDIT_TTY_SET:
> >         case AUDIT_TRIM:
> > @@ -1260,6 +1262,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >         struct audit_buffer     *ab;
> >         u16                     msg_type = nlh->nlmsg_type;
> >         struct audit_sig_info   *sig_data;
> > +       struct audit_sig_info2  *sig_data2;
> >         char                    *ctx = NULL;
> >         u32                     len;
> >
> > @@ -1519,6 +1522,30 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                                  sig_data, sizeof(*sig_data) + len);
> >                 kfree(sig_data);
> >                 break;
> > +       case AUDIT_SIGNAL_INFO2:
> > +               len = 0;
> > +               if (audit_sig_sid) {
> > +                       err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
> > +                       if (err)
> > +                               return err;
> > +               }
> > +               sig_data2 = kmalloc(sizeof(*sig_data2) + len, GFP_KERNEL);
> > +               if (!sig_data2) {
> > +                       if (audit_sig_sid)
> > +                               security_release_secctx(ctx, len);
> > +                       return -ENOMEM;
> > +               }
> > +               sig_data2->uid = from_kuid(&init_user_ns, audit_sig_uid);
> > +               sig_data2->pid = audit_sig_pid;
> > +               if (audit_sig_sid) {
> > +                       memcpy(sig_data2->ctx, ctx, len);
> > +                       security_release_secctx(ctx, len);
> > +               }
> > +               sig_data2->cid = audit_sig_cid;
> > +               audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
> > +                                sig_data2, sizeof(*sig_data2) + len);
> > +               kfree(sig_data2);
> > +               break;
> >         case AUDIT_TTY_GET: {
> >                 struct audit_tty_status s;
> >                 unsigned int t;
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index e2912924af0d..c5ac6436317e 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -345,6 +345,7 @@ extern void audit_filter_inodes(struct task_struct *tsk,
> >  extern pid_t audit_sig_pid;
> >  extern kuid_t audit_sig_uid;
> >  extern u32 audit_sig_sid;
> > +extern u64 audit_sig_cid;
> >
> >  extern int audit_filter(int msgtype, unsigned int listtype);
> >
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index eea445b7a181..0a29a00feaf1 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2405,6 +2405,7 @@ int audit_signal_info(int sig, struct task_struct *t)
> >                 else
> >                         audit_sig_uid = uid;
> >                 security_task_getsecid(current, &audit_sig_sid);
> > +               audit_sig_cid = audit_get_contid(current);
> >         }
> >
> >         if (!audit_signals || audit_dummy_context())
> > diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
> > index 9cec81209617..682fe7397762 100644
> > --- a/security/selinux/nlmsgtab.c
> > +++ b/security/selinux/nlmsgtab.c
> > @@ -132,6 +132,7 @@ struct nlmsg_perm {
> >         { AUDIT_DEL_RULE,       NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
> >         { AUDIT_USER,           NETLINK_AUDIT_SOCKET__NLMSG_RELAY    },
> >         { AUDIT_SIGNAL_INFO,    NETLINK_AUDIT_SOCKET__NLMSG_READ     },
> > +       { AUDIT_SIGNAL_INFO2,   NETLINK_AUDIT_SOCKET__NLMSG_READ     },
> >         { AUDIT_TRIM,           NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
> >         { AUDIT_MAKE_EQUIV,     NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
> >         { AUDIT_TTY_GET,        NETLINK_AUDIT_SOCKET__NLMSG_READ     },
> > --
> > 1.8.3.1
> >
> 
> 
> --
> Ondrej Mosnacek <omosnace at redhat dot com>
> Software Engineer, Security Technologies
> Red Hat, Inc.
> 
