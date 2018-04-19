From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [RFC PATCH ghak32 V2 12/13] audit: NETFILTER_PKT: record each
	container ID associated with a netNS
Date: Thu, 19 Apr 2018 09:13:17 -0400
Message-ID: <CAHC9VhSjvS81AZ55dtQVtuwJw1wSy2iJHyzERh9T6p0CR72ULA@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com>
	<66adde01c1dda792aff99a457eea576a0b08ca98.1521179281.git.rgb@redhat.com>
	<CAHC9VhR3BNRr24BPxud0X_eyFmSxUOh9bwjWNU4Z=rnDR0fENA@mail.gmail.com>
	<20180419124550.7uknp4oebvwoo67s@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180419124550.7uknp4oebvwoo67s-bcJWsdo4jJjeVoXN4CMphl7TgLCtbB0G@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2018 at 8:45 AM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 2018-04-18 22:10, Paul Moore wrote:
>> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > Add container ID auxiliary record(s) to NETFILTER_PKT event standalone
>> > records.  Iterate through all potential container IDs associated with a
>> > network namespace.
>> >
>> > Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  kernel/audit.c           |  1 +
>> >  kernel/auditsc.c         |  2 ++
>> >  net/netfilter/xt_AUDIT.c | 15 ++++++++++++++-
>> >  3 files changed, 17 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/kernel/audit.c b/kernel/audit.c
>> > index 08662b4..3c77e47 100644
>> > --- a/kernel/audit.c
>> > +++ b/kernel/audit.c
>> > @@ -2102,6 +2102,7 @@ int audit_log_container_info(struct audit_context *context,
>> >         audit_log_end(ab);
>> >         return 0;
>> >  }
>> > +EXPORT_SYMBOL(audit_log_container_info);
>> >
>> >  void audit_log_key(struct audit_buffer *ab, char *key)
>> >  {
>> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>> > index 208da962..af68d01 100644
>> > --- a/kernel/auditsc.c
>> > +++ b/kernel/auditsc.c
>> > @@ -975,6 +975,7 @@ struct audit_context *audit_alloc_local(void)
>> >         context->in_syscall = 1;
>> >         return context;
>> >  }
>> > +EXPORT_SYMBOL(audit_alloc_local);
>> >
>> >  inline void audit_free_context(struct audit_context *context)
>> >  {
>> > @@ -989,6 +990,7 @@ inline void audit_free_context(struct audit_context *context)
>> >         audit_proctitle_free(context);
>> >         kfree(context);
>> >  }
>> > +EXPORT_SYMBOL(audit_free_context);
>> >
>> >  static int audit_log_pid_context(struct audit_context *context, pid_t pid,
>> >                                  kuid_t auid, kuid_t uid, unsigned int sessionid,
>> > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
>> > index c502419..edaa456 100644
>> > --- a/net/netfilter/xt_AUDIT.c
>> > +++ b/net/netfilter/xt_AUDIT.c
>> > @@ -71,10 +71,14 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>> >  {
>> >         struct audit_buffer *ab;
>> >         int fam = -1;
>> > +       struct audit_context *context = audit_alloc_local();
>> > +       struct audit_containerid *cont;
>> > +       int i = 0;
>> > +       struct net *net;
>> >
>> >         if (audit_enabled == 0)
>> >                 goto errout;
>>
>> Do I need to say it?  I probably should ... the allocation should
>> happen after the audit_enabled check.
>
> Already fixed in V3 in my tree a couple of weeks ago...

... which you never posted, at least not anywhere I've seen.  Which
effectively means I wasted a good chunk of time reviewing this code
late last night.  Awesome.

> More timely review please?

More patience on your part?

>> > -       ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>> > +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>> >         if (ab == NULL)
>> >                 goto errout;
>> >
>> > @@ -104,7 +108,16 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
>> >
>> >         audit_log_end(ab);
>> >
>> > +       net = sock_net(NETLINK_CB(skb).sk);
>> > +       list_for_each_entry(cont, &net->audit_containerid, list) {
>> > +               char buf[14];
>> > +
>> > +               sprintf(buf, "net%u", i++);
>> > +               audit_log_container_info(context, buf, cont->id);
>> > +       }
>>
>> It seems like this could (should?) be hidden inside an audit function,
>> e.g. audit_log_net_containers() or something like that.
>
> Perhaps...  It was open-coded since at this point there are no other
> users.  That'll make this tidier though.

If the code was all contained within a single subsystem them I would
generally agree that open coding is preferable, but since we are
crossing a subsystem boundary I think it would be preferable to
abstract away the details into a separate function.

This will probably also be necessary once you change to using the
audit_net/net_generic mechanism.

-- 
paul moore
www.paul-moore.com
