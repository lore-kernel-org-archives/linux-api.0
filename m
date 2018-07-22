From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 02/10] audit: log container
	info of syscalls
Date: Sun, 22 Jul 2018 17:03:44 -0400
Message-ID: <20180722210344.kram6l7vvxniv2se@madcap2.tricolour.ca>
References: <cover.1528304203.git.rgb@redhat.com>
	<CAHC9VhS0-4XSEFFPLrOvAiSYv-XDLG-yGyB4ULRGz=AnwE6diQ@mail.gmail.com>
	<20180721202930.a7rypxc5rxi3hyiv@madcap2.tricolour.ca>
	<5467262.rd0RIe6TW9@x2>
	<20180722205510.eh2n7bcd52454dwj@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180722205510.eh2n7bcd52454dwj@madcap2.tricolour.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Steve Grubb <sgrubb@redhat.com>
Cc: simo@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, dhowells@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com, luto@kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, serge@hallyn.com, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2018-07-22 16:55, Richard Guy Briggs wrote:
> On 2018-07-22 09:32, Steve Grubb wrote:
> > On Saturday, July 21, 2018 4:29:30 PM EDT Richard Guy Briggs wrote:
> > > > > + * audit_log_contid - report container info
> > > > > + * @tsk: task to be recorded
> > > > > + * @context: task or local context for record
> > > > > + * @op: contid string description
> > > > > + */
> > > > > +int audit_log_contid(struct task_struct *tsk,
> > > > > +                            struct audit_context *context, char *op)
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
> > > > Can you explain your reason for including an "op" field in this record
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

Sorry, pressed "send" too quickly.  Also "aux0x%x" (also from the
ptrace/signals patch), "net%u" (from the AUDIT_NETFILTER_PKT patch).

> For the AUDIT_CONTAINER_ID record we have "op=set".
> 
> > -Steve
> 
> - RGB

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
