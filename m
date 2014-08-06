From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [REVIEW][PATCH 2/4] proc: Implement /proc/thread-self to point
	at the directory of the current thread
Date: Wed, 6 Aug 2014 18:32:00 +0000
Message-ID: <20140806183200.GQ14872@ubuntumail>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<87bns5cakh.fsf@x220.int.ebiederm.org>
	<20140806143500.GA23127@mail.hallyn.com>
	<871tsttr4u.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <871tsttr4u.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> > Hi Eric,
> >
> > I've not had a chance to test these, but apart from two trivial
> > comments below these look good to me, and I appreciate the feature.
> > So with the two fixes (if needed),
> >
> > Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> >> +static int proc_thread_self_readlink(struct dentry *dentry, char __user *buffer,
> >> +			      int buflen)
> >> +{
> >> +	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
> >> +	pid_t tgid = task_tgid_nr_ns(current, ns);
> >> +	pid_t pid = task_pid_nr_ns(current, ns);
> >> +	char tmp[PROC_NUMBUF + 6 + PROC_NUMBUF];
> >
> > In the extreme case you're not adding space for a \0 ?  (Unless
> > PROC_NUMBUF includes that)
> 
> PROC_NUMBUF has enough space for a sign for the maximum of 10 digits
> for a newline and a terminating \0.  So yes PROC_NUMBUF includes the
> space for a terminating \0.

Ah, I see it's 13.  Sounds good then, thanks.
