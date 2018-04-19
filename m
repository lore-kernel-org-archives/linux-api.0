From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak32 V2 09/13] audit: add containerid support for
 config/feature/user records
Date: Thu, 19 Apr 2018 08:31:09 -0400
Message-ID: <20180419123109.ab7gsnwrbtog4tbf@madcap2.tricolour.ca>
References: <cover.1521179281.git.rgb@redhat.com>
 <c34a7a95eb045a62e2443457979db9d7afbd9aee.1521179281.git.rgb@redhat.com>
 <CAHC9VhQ-i5oA48sXXnN2fP06t5=9-NMoY0bKcGXorQw2k=CK0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhQ-i5oA48sXXnN2fP06t5=9-NMoY0bKcGXorQw2k=CK0Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On 2018-04-18 21:27, Paul Moore wrote:
> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > Add container ID auxiliary records to configuration change, feature set change
> > and user generated standalone records.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c       | 50 ++++++++++++++++++++++++++++++++++++++++----------
> >  kernel/auditfilter.c |  5 ++++-
> >  2 files changed, 44 insertions(+), 11 deletions(-)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index b238be5..08662b4 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -400,8 +400,9 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
> >  {
> >         struct audit_buffer *ab;
> >         int rc = 0;
> > +       struct audit_context *context = audit_alloc_local();
> 
> We should be able to use current->audit_context here right?  If we
> can't for every caller, perhaps we pass an audit_context as an
> argument and only allocate a local context when the passed
> audit_context is NULL.
> 
> Also, if you're not comfortable always using current, just pass the
> audit_context as you do with audit_log_common_recv_msg().

As mentioned in the tree/watch/mark patch, this is all obsoleted by
making the AUDIT_CONFIG_CHANGE record a SYSCALL auxiliary record.
This review would have been more helpful a month and a half ago.

> > -       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> >         if (unlikely(!ab))
> >                 return rc;
> >         audit_log_format(ab, "%s=%u old=%u", function_name, new, old);
> > @@ -411,6 +412,8 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
> >                 allow_changes = 0; /* Something weird, deny request */
> >         audit_log_format(ab, " res=%d", allow_changes);
> >         audit_log_end(ab);
> > +       audit_log_container_info(context, "config", audit_get_containerid(current));
> > +       audit_free_context(context);
> >         return rc;
> >  }
> >
> > @@ -1058,7 +1061,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
> >         return err;
> >  }
> >
> > -static void audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
> > +static void audit_log_common_recv_msg(struct audit_context *context,
> > +                                     struct audit_buffer **ab, u16 msg_type)
> >  {
> >         uid_t uid = from_kuid(&init_user_ns, current_uid());
> >         pid_t pid = task_tgid_nr(current);
> > @@ -1068,7 +1072,7 @@ static void audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
> >                 return;
> >         }
> >
> > -       *ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
> > +       *ab = audit_log_start(context, GFP_KERNEL, msg_type);
> >         if (unlikely(!*ab))
> >                 return;
> >         audit_log_format(*ab, "pid=%d uid=%u", pid, uid);
> > @@ -1097,11 +1101,12 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
> >                                      u32 old_lock, u32 new_lock, int res)
> >  {
> >         struct audit_buffer *ab;
> > +       struct audit_context *context = audit_alloc_local();
> 
> So I know based on the other patch we are currently discussing that we
> can use current here ...
> 
> >         if (audit_enabled == AUDIT_OFF)
> >                 return;
> >
> > -       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_FEATURE_CHANGE);
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_FEATURE_CHANGE);
> >         if (!ab)
> >                 return;
> >         audit_log_task_info(ab, current);
> > @@ -1109,6 +1114,8 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
> >                          audit_feature_names[which], !!old_feature, !!new_feature,
> >                          !!old_lock, !!new_lock, res);
> >         audit_log_end(ab);
> > +       audit_log_container_info(context, "feature", audit_get_containerid(current));
> > +       audit_free_context(context);
> >  }
> >
> >  static int audit_set_feature(struct sk_buff *skb)
> > @@ -1337,13 +1344,15 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >
> >                 err = audit_filter(msg_type, AUDIT_FILTER_USER);
> >                 if (err == 1) { /* match or error */
> > +                       struct audit_context *context = audit_alloc_local();
> 
> I'm pretty sure we can use current here.
> 
> >                         err = 0;
> >                         if (msg_type == AUDIT_USER_TTY) {
> >                                 err = tty_audit_push();
> >                                 if (err)
> >                                         break;
> >                         }
> > -                       audit_log_common_recv_msg(&ab, msg_type);
> > +                       audit_log_common_recv_msg(context, &ab, msg_type);
> >                         if (msg_type != AUDIT_USER_TTY)
> >                                 audit_log_format(ab, " msg='%.*s'",
> >                                                  AUDIT_MESSAGE_TEXT_MAX,
> > @@ -1359,6 +1368,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                                 audit_log_n_untrustedstring(ab, data, size);
> >                         }
> >                         audit_log_end(ab);
> > +                       audit_log_container_info(context, "user",
> > +                                                audit_get_containerid(current));
> > +                       audit_free_context(context);
> >                 }
> >                 break;
> >         case AUDIT_ADD_RULE:
> > @@ -1366,9 +1378,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                 if (nlmsg_len(nlh) < sizeof(struct audit_rule_data))
> >                         return -EINVAL;
> >                 if (audit_enabled == AUDIT_LOCKED) {
> > -                       audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
> > +                       struct audit_context *context = audit_alloc_local();
> 
> Pretty sure current can be used here too.  In fact I think everywhere
> where we are processing commands from netlink we can use current as I
> believe the entire netlink stack is processed in the context of the
> caller.
> 
> > +                       audit_log_common_recv_msg(context, &ab, AUDIT_CONFIG_CHANGE);
> >                         audit_log_format(ab, " audit_enabled=%d res=0", audit_enabled);
> >                         audit_log_end(ab);
> > +                       audit_log_container_info(context, "config",
> > +                                                audit_get_containerid(current));
> > +                       audit_free_context(context);
> >                         return -EPERM;
> >                 }
> >                 err = audit_rule_change(msg_type, seq, data, nlmsg_len(nlh));
> > @@ -1376,17 +1393,23 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >         case AUDIT_LIST_RULES:
> >                 err = audit_list_rules_send(skb, seq);
> >                 break;
> > -       case AUDIT_TRIM:
> > +       case AUDIT_TRIM: {
> > +               struct audit_context *context = audit_alloc_local();
> 
> Same.
> 
> >                 audit_trim_trees();
> > -               audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
> > +               audit_log_common_recv_msg(context, &ab, AUDIT_CONFIG_CHANGE);
> >                 audit_log_format(ab, " op=trim res=1");
> >                 audit_log_end(ab);
> > +               audit_log_container_info(context, "config",
> > +                                        audit_get_containerid(current));
> > +               audit_free_context(context);
> >                 break;
> > +       }
> >         case AUDIT_MAKE_EQUIV: {
> >                 void *bufp = data;
> >                 u32 sizes[2];
> >                 size_t msglen = nlmsg_len(nlh);
> >                 char *old, *new;
> > +               struct audit_context *context = audit_alloc_local();
> 
> Same.
> 
> >                 err = -EINVAL;
> >                 if (msglen < 2 * sizeof(u32))
> > @@ -1408,7 +1431,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                 /* OK, here comes... */
> >                 err = audit_tag_tree(old, new);
> >
> > -               audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
> > +               audit_log_common_recv_msg(context, &ab, AUDIT_CONFIG_CHANGE);
> >
> >                 audit_log_format(ab, " op=make_equiv old=");
> >                 audit_log_untrustedstring(ab, old);
> > @@ -1418,6 +1441,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                 audit_log_end(ab);
> >                 kfree(old);
> >                 kfree(new);
> > +               audit_log_container_info(context, "config",
> > +                                        audit_get_containerid(current));
> > +               audit_free_context(context);
> >                 break;
> >         }
> >         case AUDIT_SIGNAL_INFO:
> > @@ -1459,6 +1485,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                 struct audit_tty_status s, old;
> >                 struct audit_buffer     *ab;
> >                 unsigned int t;
> > +               struct audit_context *context = audit_alloc_local();
> 
> Same.
> 
> >                 memset(&s, 0, sizeof(s));
> >                 /* guard against past and future API changes */
> > @@ -1477,12 +1504,15 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                 old.enabled = t & AUDIT_TTY_ENABLE;
> >                 old.log_passwd = !!(t & AUDIT_TTY_LOG_PASSWD);
> >
> > -               audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
> > +               audit_log_common_recv_msg(context, &ab, AUDIT_CONFIG_CHANGE);
> >                 audit_log_format(ab, " op=tty_set old-enabled=%d new-enabled=%d"
> >                                  " old-log_passwd=%d new-log_passwd=%d res=%d",
> >                                  old.enabled, s.enabled, old.log_passwd,
> >                                  s.log_passwd, !err);
> >                 audit_log_end(ab);
> > +               audit_log_container_info(context, "config",
> > +                                        audit_get_containerid(current));
> > +               audit_free_context(context);
> >                 break;
> >         }
> >         default:
> > diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> > index c4c8746..5f7f4d6 100644
> > --- a/kernel/auditfilter.c
> > +++ b/kernel/auditfilter.c
> > @@ -1109,11 +1109,12 @@ static void audit_log_rule_change(char *action, struct audit_krule *rule, int re
> >         struct audit_buffer *ab;
> >         uid_t loginuid = from_kuid(&init_user_ns, audit_get_loginuid(current));
> >         unsigned int sessionid = audit_get_sessionid(current);
> > +       struct audit_context *context = audit_alloc_local();
> >
> >         if (!audit_enabled)
> >                 return;
> 
> Well, first I think we should be able to get rid of the local context,
> but if for some reason we can't use current->audit_context then do the
> allocation after the audit_enabled check.
> 
> > -       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> >         if (!ab)
> >                 return;
> >         audit_log_format(ab, "auid=%u ses=%u" ,loginuid, sessionid);
> > @@ -1122,6 +1123,8 @@ static void audit_log_rule_change(char *action, struct audit_krule *rule, int re
> >         audit_log_key(ab, rule->filterkey);
> >         audit_log_format(ab, " list=%d res=%d", rule->listnr, res);
> >         audit_log_end(ab);
> > +       audit_log_container_info(context, "config", audit_get_containerid(current));
> > +       audit_free_context(context);
> >  }
> 
> -- 
> paul moore
> www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
