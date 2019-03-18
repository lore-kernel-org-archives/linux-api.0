From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V5 05/10] audit: add containerid support for
 ptrace and signals
Date: Mon, 18 Mar 2019 15:29:44 -0400
Message-ID: <20190318192944.snmolq6zcawltrvv@madcap2.tricolour.ca>
References: <cover.1552665316.git.rgb@redhat.com>
 <a5a612bff629574cf4b678e7c7a9315e0e60a27c.1552665316.git.rgb@redhat.com>
 <20190318190415.GB4111@hmswarspite.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190318190415.GB4111@hmswarspite.think-freely.org>
Sender: netdev-owner@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On 2019-03-18 15:04, Neil Horman wrote:
> On Fri, Mar 15, 2019 at 02:29:53PM -0400, Richard Guy Briggs wrote:
> > Add audit container identifier support to ptrace and signals.  In
> > particular, the "ref" field provides a way to label the auxiliary record
> > to which it is associated.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Serge Hallyn <serge@hallyn.com>
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h |  1 +
> >  kernel/audit.c        |  2 ++
> >  kernel/audit.h        |  2 ++
> >  kernel/auditsc.c      | 23 +++++++++++++++++------
> >  4 files changed, 22 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 43438192ca2a..ebd6625ca80e 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -35,6 +35,7 @@ struct audit_sig_info {
> >  	uid_t		uid;
> >  	pid_t		pid;
> >  	char		ctx[0];
> > +	u64		cid;
> >  };
> Sorry, just noticed this.  How does this work?  Given that ctx[] is a variable
> length array, one assumes that the receiver of this message (userspace
> applications by the looks of it, presume that the ctx data occupies the skb from
> the byte following pid to the end of the transmitted buffer.  How are they to
> know that the last byte is actually the cid value?  Wouldn't it be better to
> move cid above ctx[0], so that the semantics of the variable length data are
> preserved?
> 
> Or am I missing something?

Nope you're not missing anything, but I am!  That's a bug.  Thanks for
spotting that!

> otherwise this looks ok to me.
> Neil
> 
> >  
> >  struct audit_buffer;
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 8cc0e88d7f2a..cfa659b3f6c4 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -138,6 +138,7 @@ struct audit_net {
> >  kuid_t		audit_sig_uid = INVALID_UID;
> >  pid_t		audit_sig_pid = -1;
> >  u32		audit_sig_sid = 0;
> > +u64		audit_sig_cid = AUDIT_CID_UNSET;
> >  
> >  /* Records can be lost in several ways:
> >     0) [suppressed in audit_alloc]
> > @@ -1515,6 +1516,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >  			memcpy(sig_data->ctx, ctx, len);
> >  			security_release_secctx(ctx, len);
> >  		}
> > +		sig_data->cid = audit_sig_cid;
> >  		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
> >  				 sig_data, sizeof(*sig_data) + len);
> >  		kfree(sig_data);
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index c00e2ee3c6b3..c5ac6436317e 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -148,6 +148,7 @@ struct audit_context {
> >  	kuid_t		    target_uid;
> >  	unsigned int	    target_sessionid;
> >  	u32		    target_sid;
> > +	u64		    target_cid;
> >  	char		    target_comm[TASK_COMM_LEN];
> >  
> >  	struct audit_tree_refs *trees, *first_trees;
> > @@ -344,6 +345,7 @@ extern void audit_filter_inodes(struct task_struct *tsk,
> >  extern pid_t audit_sig_pid;
> >  extern kuid_t audit_sig_uid;
> >  extern u32 audit_sig_sid;
> > +extern u64 audit_sig_cid;
> >  
> >  extern int audit_filter(int msgtype, unsigned int listtype);
> >  
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index a8c8b44b954d..f04e115df5dc 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -113,6 +113,7 @@ struct audit_aux_data_pids {
> >  	kuid_t			target_uid[AUDIT_AUX_PIDS];
> >  	unsigned int		target_sessionid[AUDIT_AUX_PIDS];
> >  	u32			target_sid[AUDIT_AUX_PIDS];
> > +	u64			target_cid[AUDIT_AUX_PIDS];
> >  	char 			target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
> >  	int			pid_count;
> >  };
> > @@ -1514,7 +1515,7 @@ static void audit_log_exit(void)
> >  	for (aux = context->aux_pids; aux; aux = aux->next) {
> >  		struct audit_aux_data_pids *axs = (void *)aux;
> >  
> > -		for (i = 0; i < axs->pid_count; i++)
> > +		for (i = 0; i < axs->pid_count; i++) {
> >  			if (audit_log_pid_context(context, axs->target_pid[i],
> >  						  axs->target_auid[i],
> >  						  axs->target_uid[i],
> > @@ -1522,14 +1523,20 @@ static void audit_log_exit(void)
> >  						  axs->target_sid[i],
> >  						  axs->target_comm[i]))
> >  				call_panic = 1;
> > +			audit_log_contid(context, axs->target_cid[i]);
> > +		}
> >  	}
> >  
> > -	if (context->target_pid &&
> > -	    audit_log_pid_context(context, context->target_pid,
> > -				  context->target_auid, context->target_uid,
> > -				  context->target_sessionid,
> > -				  context->target_sid, context->target_comm))
> > +	if (context->target_pid) {
> > +		if (audit_log_pid_context(context, context->target_pid,
> > +					  context->target_auid,
> > +					  context->target_uid,
> > +					  context->target_sessionid,
> > +					  context->target_sid,
> > +					  context->target_comm))
> >  			call_panic = 1;
> > +		audit_log_contid(context, context->target_cid);
> > +	}
> >  
> >  	if (context->pwd.dentry && context->pwd.mnt) {
> >  		ab = audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
> > @@ -2360,6 +2367,7 @@ void __audit_ptrace(struct task_struct *t)
> >  	context->target_uid = task_uid(t);
> >  	context->target_sessionid = audit_get_sessionid(t);
> >  	security_task_getsecid(t, &context->target_sid);
> > +	context->target_cid = audit_get_contid(t);
> >  	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
> >  }
> >  
> > @@ -2387,6 +2395,7 @@ int audit_signal_info(int sig, struct task_struct *t)
> >  		else
> >  			audit_sig_uid = uid;
> >  		security_task_getsecid(current, &audit_sig_sid);
> > +		audit_sig_cid = audit_get_contid(current);
> >  	}
> >  
> >  	if (!audit_signals || audit_dummy_context())
> > @@ -2400,6 +2409,7 @@ int audit_signal_info(int sig, struct task_struct *t)
> >  		ctx->target_uid = t_uid;
> >  		ctx->target_sessionid = audit_get_sessionid(t);
> >  		security_task_getsecid(t, &ctx->target_sid);
> > +		ctx->target_cid = audit_get_contid(t);
> >  		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
> >  		return 0;
> >  	}
> > @@ -2421,6 +2431,7 @@ int audit_signal_info(int sig, struct task_struct *t)
> >  	axp->target_uid[axp->pid_count] = t_uid;
> >  	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
> >  	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
> > +	axp->target_cid[axp->pid_count] = audit_get_contid(t);
> >  	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
> >  	axp->pid_count++;
> >  
> > -- 
> > 1.8.3.1
> > 
> > 

- RGB
