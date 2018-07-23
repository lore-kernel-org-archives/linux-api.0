From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 02/10] audit: log container info of syscalls
Date: Mon, 23 Jul 2018 09:19:47 -0400
Message-ID: <3318670.y8SpQ3RC2W@x2>
References: <cover.1528304203.git.rgb@redhat.com> <5467262.rd0RIe6TW9@x2> <20180722205510.eh2n7bcd52454dwj@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180722205510.eh2n7bcd52454dwj@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Sunday, July 22, 2018 4:55:10 PM EDT Richard Guy Briggs wrote:
> On 2018-07-22 09:32, Steve Grubb wrote:
> > On Saturday, July 21, 2018 4:29:30 PM EDT Richard Guy Briggs wrote:
> > > > > + * audit_log_contid - report container info
> > > > > + * @tsk: task to be recorded
> > > > > + * @context: task or local context for record
> > > > > + * @op: contid string description
> > > > > + */
> > > > > +int audit_log_contid(struct task_struct *tsk,
> > > > > +                            struct audit_context *context, char
> > > > > *op)
> > > > > +{
> > > > > +       struct audit_buffer *ab;
> > > > > +
> > > > > +       if (!audit_contid_set(tsk))
> > > > > +               return 0;
> > > > > +       /* Generate AUDIT_CONTAINER record with container ID */
> > > > > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER);
> > > > > +       if (!ab)
> > > > > +               return -ENOMEM;
> > > > > +       audit_log_format(ab, "op=%s contid=%llu",
> > > > > +                        op, audit_get_contid(tsk));
> > > > 
> > > > Can you explain your reason for including an "op" field in this
> > > > record
> > > > type?  I've been looking at the rest of the patches in this patchset
> > > > and it seems to be used more as an indicator of the record's
> > > > generating context rather than any sort of audit container ID
> > > > operation.
> > > 
> > > "action" might work, but that's netfilter and numeric... "kind"?
> > > Nothing else really seems to fit from a field name, type or lack of
> > > searchability perspective.
> > > 
> > > Steve, do you have an opinion?
> > 
> > We only have 1 sample event where we have op=task. What are the other
> > possible values?
> 
> For the AUDIT_CONTAINER record we have op= "task", "target" (from the
> ptrace and signals patch), "tty".
> 
> For the AUDIT_CONTAINER_ID record we have "op=set".

Since the purpose of this record is to log the container id, I think that is 
all that is needed. We can get the context from the other records in the 
event. I'd suggest dropping the "op" field.

-Steve
