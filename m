From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH 3/4] seccomp: Add SECCOMP_USER_NOTIF_FLAG_PIDFD to get
 pidfd on listener trap
Date: Mon, 27 Jan 2020 05:06:28 +0000
Message-ID: <20200127050627.GA21575@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200124091743.3357-1-sargun@sargun.me>
 <20200124091743.3357-4-sargun@sargun.me>
 <20200126040325.5eimmm7hli5qcqrr@yavin.dot.cyphar.com>
 <20200126041439.liwfmb4h74zmhi76@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200126041439.liwfmb4h74zmhi76@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>
Cc: Aleksa Sarai <cyphar@cyphar.com>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, christian.brauner@ubuntu.com
List-Id: linux-api@vger.kernel.org

On Sun, Jan 26, 2020 at 03:14:39PM +1100, Aleksa Sarai wrote:
> On 2020-01-26, Aleksa Sarai <cyphar@cyphar.com> wrote:
> > On 2020-01-24, Sargun Dhillon <sargun@sargun.me> wrote:
> > >  static long seccomp_notify_recv(struct seccomp_filter *filter,
> > >  				void __user *buf)
> > >  {
> > >  	struct seccomp_knotif *knotif = NULL, *cur;
> > >  	struct seccomp_notif unotif;
> > > +	struct task_struct *group_leader;
> > > +	bool send_pidfd;
> > >  	ssize_t ret;
> > >  
> > > +	if (copy_from_user(&unotif, buf, sizeof(unotif)))
> > > +		return -EFAULT;
> > >  	/* Verify that we're not given garbage to keep struct extensible. */
> > > -	ret = check_zeroed_user(buf, sizeof(unotif));
> > > -	if (ret < 0)
> > > -		return ret;
> > > -	if (!ret)
> > > +	if (unotif.id ||
> > > +	    unotif.pid ||
> > > +	    memchr_inv(&unotif.data, 0, sizeof(unotif.data)) ||
> > > +	    unotif.pidfd)
> > > +		return -EINVAL;
> > 
> > IMHO this check is more confusing than the original check_zeroed_user().
> > Something like the following is simpler and less prone to forgetting to
> > add a new field in the future:
> > 
I'm all for this, originally my patch read:

__u32 flags = 0;
swap(unotif.flags, flags);
if (memchr(&unotif, 0, sizeof(unotif))
	return -EINVAL;

--- And then check flags appropriately. I'm not sure if this is "better",
as I didn't see any other implementations that look like this in the
kernel. What do you think? It could even look "simpler", as in:

__u32 flags;

if (copy_from_user(....))
	return -EFAULT;
flags = unotif.flags;
unotif.flags = 0;
if (memchr_inv(&unotif, 0, sizeof(unotif)))
	return -EINVAL;


Are either of those preferential, reasonable, or at a minimum inoffensive?
> > 	if (memchr_inv(&unotif, 0, sizeof(unotif)))
> > 		return -EINVAL;
> 
Wouldn't this fail if flags was set to any value? We either need to zero
out flags prior to checking, or split it into range checks that exclude
flags.

> Also the check in the patch doesn't ensure that any unnamed padding is
> zeroed -- memchr_inv(&unotif, 0, sizeof(unotif)) does.
> 
> -- 
> Aleksa Sarai
> Senior Software Engineer (Containers)
> SUSE Linux GmbH
> <https://www.cyphar.com/>
