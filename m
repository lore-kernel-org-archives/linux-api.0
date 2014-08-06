From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 2/4] proc: Implement /proc/thread-self to point at the directory of the current thread
Date: Wed, 06 Aug 2014 11:22:25 -0700
Message-ID: <871tsttr4u.fsf@x220.int.ebiederm.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<87bns5cakh.fsf@x220.int.ebiederm.org>
	<20140806143500.GA23127@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140806143500.GA23127-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
	message of "Wed, 6 Aug 2014 16:35:00 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> Hi Eric,
>
> I've not had a chance to test these, but apart from two trivial
> comments below these look good to me, and I appreciate the feature.
> So with the two fixes (if needed),
>
> Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

>> +static int proc_thread_self_readlink(struct dentry *dentry, char __user *buffer,
>> +			      int buflen)
>> +{
>> +	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
>> +	pid_t tgid = task_tgid_nr_ns(current, ns);
>> +	pid_t pid = task_pid_nr_ns(current, ns);
>> +	char tmp[PROC_NUMBUF + 6 + PROC_NUMBUF];
>
> In the extreme case you're not adding space for a \0 ?  (Unless
> PROC_NUMBUF includes that)

PROC_NUMBUF has enough space for a sign for the maximum of 10 digits
for a newline and a terminating \0.  So yes PROC_NUMBUF includes the
space for a terminating \0.

Eric
