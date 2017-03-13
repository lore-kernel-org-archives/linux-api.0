From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 10/13] mm: Introduce first class virtual address
 spaces
Date: Tue, 14 Mar 2017 07:52:25 +0800
Message-ID: <20170313235225.GA15359@kroah.com>
References: <20170313221415.9375-1-till.smejkal@gmail.com>
 <20170313221415.9375-11-till.smejkal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170313221415.9375-11-till.smejkal@gmail.com>
Sender: owner-linux-aio@kvack.org
To: Till Smejkal <till.smejkal@googlemail.com>
Cc: Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Miao <realmz6@gmail.com>, Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@daveml>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 13, 2017 at 03:14:12PM -0700, Till Smejkal wrote:

There's no way with that many cc: lists and people that this is really
making it through very many people's filters and actually on a mailing
list.  Please trim them down.

Minor sysfs questions/issues:

> +struct vas {
> +	struct kobject kobj;		/* < the internal kobject that we use *
> +					 *   for reference counting and sysfs *
> +					 *   handling.                        */
> +
> +	int id;				/* < ID                               */
> +	char name[VAS_MAX_NAME_LENGTH];	/* < name                             */

The kobject has a name, why not use that?

> +
> +	struct mutex mtx;		/* < lock for parallel access.        */
> +
> +	struct mm_struct *mm;		/* < a partial memory map containing  *
> +					 *   all mappings of this VAS.        */
> +
> +	struct list_head link;		/* < the link in the global VAS list. */
> +	struct rcu_head rcu;		/* < the RCU helper used for          *
> +					 *   asynchronous VAS deletion.       */
> +
> +	u16 refcount;			/* < how often is the VAS attached.   */

The kobject has a refcount, use that?  Don't have 2 refcounts in the
same structure, that way lies madness.  And bugs, lots of bugs...

And if this really is a refcount (hint, I don't think it is), you should
use the refcount_t type.

> +/**
> + * The sysfs structure we need to handle attributes of a VAS.
> + **/
> +struct vas_sysfs_attr {
> +	struct attribute attr;
> +	ssize_t (*show)(struct vas *vas, struct vas_sysfs_attr *vsattr,
> +			char *buf);
> +	ssize_t (*store)(struct vas *vas, struct vas_sysfs_attr *vsattr,
> +			 const char *buf, size_t count);
> +};
> +
> +#define VAS_SYSFS_ATTR(NAME, MODE, SHOW, STORE)				\
> +static struct vas_sysfs_attr vas_sysfs_attr_##NAME =			\
> +	__ATTR(NAME, MODE, SHOW, STORE)

__ATTR_RO and __ATTR_RW should work better for you.  If you really need
this.

Oh, and where is the Documentation/ABI/ updates to try to describe the
sysfs structure and files?  Did I miss that in the series?

> +static ssize_t __show_vas_name(struct vas *vas, struct vas_sysfs_attr *vsattr,
> +			       char *buf)
> +{
> +	return scnprintf(buf, PAGE_SIZE, "%s", vas->name);

It's a page size, just use sprintf() and be done with it.  No need to
ever check, you "know" it will be correct.

Also, what about a trailing '\n' for these attributes?

Oh wait, why have a name when the kobject name is already there in the
directory itself?  Do you really need this?

> +/**
> + * The ktype data structure representing a VAS.
> + **/
> +static struct kobj_type vas_ktype = {
> +	.sysfs_ops = &vas_sysfs_ops,
> +	.release = __vas_release,

Why the odd __vas* naming?  What's wrong with vas_release?


> +	.default_attrs = vas_default_attr,
> +};
> +
> +
> +/***
> + * Internally visible functions
> + ***/
> +
> +/**
> + * Working with the global VAS list.
> + **/
> +static inline void vas_remove(struct vas *vas)

<snip>

You have a ton of inline functions, for no good reason.  Make them all
"real" functions please.  Unless you can measure the size/speed
differences?  If so, please say so.


thanks,

greg k-h

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
