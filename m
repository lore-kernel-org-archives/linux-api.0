From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v25 12/12] LRNG - add interface for gathering of raw entropy
Date: Thu, 21 Nov 2019 16:18:18 +0100
Message-ID: <23500762.5LfuSYdpsK@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <3610406.x8mDjznOIz@positron.chronox.de> <87a78pl8xp.fsf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87a78pl8xp.fsf@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nstange@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, "Peter, Matthias" <matthias>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 21. November 2019, 13:18:10 CET schrieb Nicolai Stange:

Hi Nicolai,

> Hi Stephan,
>=20
> two general remarks on debugfs usage below
>=20
> Stephan M=FCller <smueller@chronox.de> writes:
> > diff --git a/drivers/char/lrng/lrng_testing.c
> > b/drivers/char/lrng/lrng_testing.c new file mode 100644
> > index 000000000000..5c33d3bd2172
> > --- /dev/null
> > +++ b/drivers/char/lrng/lrng_testing.c
>=20
> <snip>
>=20
> > +/*
> > + * This data structure holds the dentry's of the debugfs files
> > establishing + * the interface to user space.
> > + */
> > +struct lrng_raw_debugfs {
> > +	struct dentry *lrng_raw_debugfs_root; /* root dentry */
> > +	struct dentry *lrng_raw_debugfs_lrng_raw; /* .../lrng_raw */
> > +};
> > +
> > +static struct lrng_raw_debugfs lrng_raw_debugfs;
> > +
> > +/* DebugFS operations and definition of the debugfs files */
> > +static ssize_t lrng_raw_read(struct file *file, char __user *to,
> > +			     size_t count, loff_t *ppos)
> > +{
> > +	loff_t pos =3D *ppos;
> > +	int ret;
> > +
> > +	if (!count)
> > +		return 0;
> > +	lrng_raw_entropy_init();
> > +	ret =3D lrng_raw_extract_user(to, count);
> > +	lrng_raw_entropy_fini();
> > +	if (ret < 0)
> > +		return ret;
> > +	count -=3D ret;
> > +	*ppos =3D pos + count;
> > +	return ret;
> > +}
> > +
> > +/* Module init: allocate memory, register the debugfs files */
> > +static int lrng_raw_debugfs_init(void)
> > +{
> > +	lrng_raw_debugfs.lrng_raw_debugfs_root =3D
> > +		debugfs_create_dir(KBUILD_MODNAME, NULL);
> > +	if (IS_ERR(lrng_raw_debugfs.lrng_raw_debugfs_root)) {
> > +		lrng_raw_debugfs.lrng_raw_debugfs_root =3D NULL;
> > +		return PTR_ERR(lrng_raw_debugfs.lrng_raw_debugfs_root);
> > +	}
>=20
> I think pointers returned by the debugfs API are not supposed to get
> checked for NULL/IS_ERR(), c.f commit ff9fb72bc077 ("debugfs: return
> error values, not NULL") or the the output from
>=20
>   git log --pretty=3Doneline | grep 'no need to check return value of
> debugfs_create'
>=20
> (Also the above code is dubious: you're effectively returning
>  PTR_ERR(NULL)).

Removed the check compliant to the mentioned patches.
>=20
> > +	return 0;
> > +}
> > +
> > +static struct file_operations lrng_raw_name_fops =3D {
> > +	.owner =3D THIS_MODULE,
> > +	.read =3D lrng_raw_read,
> > +};
> > +
> > +static int lrng_raw_debugfs_init_name(void)
> > +{
> > +	lrng_raw_debugfs.lrng_raw_debugfs_lrng_raw =3D
> > +		debugfs_create_file("lrng_raw", 0400,
> > +				    lrng_raw_debugfs.lrng_raw_debugfs_root,
> > +				    NULL, &lrng_raw_name_fops);q
>=20
> CONFIG_LRNG_TESTING is a bool and thus, this debugfs file can't ever get
> removed. Even if it could, this inode hasn't got any data associated
> with it and so file removal would not be a problem for lrng_raw_read().

Correct.
>=20
> Please consider using debugfs_create_file_unsafe() instead to save
> debugfs from kmalloc()ing a proxy file_operations protecting your fops
> against concurrent file removal.

Yes, you are correct. Changed.
>=20
> > +	if (IS_ERR(lrng_raw_debugfs.lrng_raw_debugfs_lrng_raw)) {
> > +		lrng_raw_debugfs.lrng_raw_debugfs_lrng_raw =3D NULL;
> > +		return PTR_ERR(lrng_raw_debugfs.lrng_raw_debugfs_lrng_raw);
> > +	}
>=20
> Same comment regarding return value checking applies here.

Same here: I removed the check.

With that, I also removed the static variable to maintain the two dentries=
=20
following the examples seen in other kernel code. Also, the __exit function=
 is=20
removed as we do not need it as you pointed out.

Thanks a lot.
>=20
> Thanks,
>=20
> Nicolai
>=20
> > +	return 0;
> > +}
> > +
> > +static int __init lrng_raw_init(void)
> > +{
> > +	int ret =3D lrng_raw_debugfs_init();
> > +
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret =3D lrng_raw_debugfs_init_name();
> > +	if (ret < 0)
> > +		debugfs_remove_recursive(
> > +					lrng_raw_debugfs.lrng_raw_debugfs_root);
> > +
> > +	return ret;
> > +}
> > +
> > +static void __exit lrng_raw_exit(void)
> > +{
> > +	debugfs_remove_recursive(lrng_raw_debugfs.lrng_raw_debugfs_root);
> > +}
> > +
> > +module_init(lrng_raw_init);
> > +module_exit(lrng_raw_exit);
> > +
> > +MODULE_LICENSE("Dual BSD/GPL");
> > +MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
> > +MODULE_DESCRIPTION("Kernel module for gathering raw entropy");


Ciao
Stephan
