From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: kdbus: add driver skeleton, ioctl entry points and utility
 functions
Date: Fri, 31 Oct 2014 00:45:33 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1410302224230.5308@nanos>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-4-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414620056-6675-4-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:
> +/* kdbus major */
> +static unsigned int kdbus_major;
> +
> +/* map of minors to objects */
> +static DEFINE_IDR(kdbus_minor_idr);
> +
> +/* kdbus minor lock */
> +static DEFINE_SPINLOCK(kdbus_minor_lock);
> +
> +int kdbus_minor_init(void)
> +{
> +	int ret;
> +
> +	ret = __register_chrdev(0, 0, 0xfffff, KBUILD_MODNAME,

0xfffff? Random number pulled out of thin air or is there some
sensible explanation for this choice?

> +				&kdbus_handle_ops);
> +	if (ret < 0)
> +		return ret;
> +
> +	kdbus_major = ret;

So minor_init actually assigns the major number ...

> +	return 0;
> +}
> +
> +void kdbus_minor_exit(void)
> +{
> +	__unregister_chrdev(kdbus_major, 0, 0xfffff, KBUILD_MODNAME);

So we have the magic 0xfffff constant at two places to make sure that
it is updated in sync.

> +	idr_destroy(&kdbus_minor_idr);
> +}
> +
> +static void *kdbus_minor_pack(enum kdbus_minor_type type, void *ptr)
> +{
> +	unsigned long p = (unsigned long)ptr;
> +
> +	BUILD_BUG_ON(KDBUS_MINOR_CNT > 4);

We certainly want a build bug in some random function with another
magic number for a completely undocumented enum, which does neither
explain what its enum constants mean nor does have a comment that it
is limited to 0-3 for a very good reason.

And of course any not overloaded pointer defaults to
KDBUS_MINOR_CONTROL which is always valid...

> +
> +	if (WARN_ON(p & 0x3UL || type >= KDBUS_MINOR_CNT))

0x03UL is a very descriptive constant ....

> +		return NULL;
> +
> +	return (void *)(p | (unsigned long)type);
> +}
> +
> +static enum kdbus_minor_type kdbus_minor_unpack(void **ptr)
> +{
> +	unsigned long p = (unsigned long)*ptr;
> +
> +	*ptr = (void *)(p & ~0x3UL);
> +	return p & 0x3UL;

I'm really excited about the intuitive naming conventions
here. minor_init() initializes kdbus_major and this pack/unpack stuff
converts a pointer to carry a type and vice versa. Of course that
stuff lacks any comment in order to accelerate reviews, right?

I really had to look more than twice to figure out that this function
serves two purposes;

 - Remove the type overload from the pointer

 - Return the type retrieved from the pointer.

Aside of that: What on earth has minor to do with this?

For heavens sake. Minor is referring to a minor number in the context
of character devices, right?

And a number does not map at all to a randomly overloaded pointer
AFAICT.

> +/**
> + * kdbus_minor_set() - set an existing minor type of a kdbus device node

Groan. The name choices are just ass backwards to be honest. And the
explanation of the function is even worse:

   "set an existing minor type of a kdbus device node"

What the heck is an 'existing minor type' ?

Ah, you mean if the type does not exist, i.e. it is >= KDBUS_MINOR_CNT)
then the idr entry will be replaced by a NULL pointer silently.

Aside of that if ptr has one of the lower two bits set, and the call
tries to change its type then we get a WARN_ON in dmesg and happily
assign a NULL pointer to the idr entry for that minor number.

Makes a lot of sense. We'll see the fallout later...

> + * @devt:	The device node to remove

So @devt is removed? The documentation of idr_replace() tells a
different story.

> + * @type:	New type to set
> + * @ptr:	Associated pointer when node was initially registered

Why is this a void pointer? Are we dealing with arbitrary node types
here?

> + */
> +void kdbus_minor_set(dev_t devt, enum kdbus_minor_type type, void *ptr)
> +{
> +	unsigned int minor = MINOR(devt);
> +
> +	ptr = kdbus_minor_pack(type, ptr);
> +
> +	spin_lock(&kdbus_minor_lock);

Why is this a spinlock and not a mutex?

> +	ptr = idr_replace(&kdbus_minor_idr, ptr, minor);

What's the value of this pointless assignment? Pacify gcc?

> +static int kdbus_handle_release(struct inode *inode, struct file *file)
> +{
> +	struct kdbus_handle *handle = file->private_data;
> +
> +	switch (handle->type) {
> +	case KDBUS_HANDLE_CONTROL_DOMAIN_OWNER:
> +		kdbus_domain_disconnect(handle->domain_owner);
> +		kdbus_domain_unref(handle->domain_owner);
> +		break;
> +
> +	case KDBUS_HANDLE_CONTROL_BUS_OWNER:
> +		kdbus_bus_disconnect(handle->bus_owner);
> +		kdbus_bus_unref(handle->bus_owner);
> +		break;
> +
> +	case KDBUS_HANDLE_ENDPOINT_OWNER:
> +		kdbus_ep_disconnect(handle->ep_owner);
> +		kdbus_ep_unref(handle->ep_owner);
> +		break;
> +
> +	case KDBUS_HANDLE_ENDPOINT_CONNECTED:
> +		kdbus_conn_disconnect(handle->conn, false);
> +		kdbus_conn_unref(handle->conn);
> +		break;
> +
> +	default:
> +		break;

Silent acceptance of type being unknown?

> +static int kdbus_copy_from_user(void *dest,
> +				void __user *user_ptr,
> +				size_t size)
> +{
> +	if (!KDBUS_IS_ALIGNED8((uintptr_t)user_ptr))
> +		return -EFAULT;

Completely undocumented requirement and there is no reason WHY we need
KDBUS_IS_ALIGNED8 to figure that out ....

> +static int kdbus_handle_transform(struct kdbus_handle *handle,
> +				  enum kdbus_handle_type old_type,
> +				  enum kdbus_handle_type new_type,
> +				  void *ctx_ptr)
> +{
> +	int ret = -EBADFD;
> +
> +	/*
> +	 * This transforms a handle from one state into another. Only a single
> +	 * transformation is allowed per handle, and it must be one of:
> +	 *   CONTROL -> CONTROL_DOMAIN_OWNER
> +	 *           -> CONTROL_BUS_OWNER
> +	 *        EP -> EP_CONNECTED
> +	 *           -> EP_OWNER

And that's magically enforced by what? new_type is not sanity checked
here at all and there is no requirement for the call site to do so.

> +/* kdbus control device commands */
> +static long kdbus_handle_ioctl_control(struct file *file, unsigned int cmd,
> +				       void __user *buf)
> +{
> +	struct kdbus_handle *handle = file->private_data;
> +	struct kdbus_bus *bus = NULL;
> +	struct kdbus_cmd_make *make;
> +	struct kdbus_domain *domain = NULL;
> +	umode_t mode = 0600;
> +	void *p = NULL;
> +	int ret;
> +
> +	switch (cmd) {
> +	case KDBUS_CMD_BUS_MAKE: {
> +		kgid_t gid = KGIDT_INIT(0);
> +		struct kdbus_bloom_parameter bloom;
> +		char *name;
> +
> +		ret = kdbus_memdup_user(buf, &p, sizeof(*make),
> +					KDBUS_MAKE_MAX_SIZE);
> +		if (ret < 0)
> +			break;
> +
> +		make = p;

Another great coding convention stolen from some ramdonly misdesigned
user space app?

     ret = kdbus_memdup_user(buf, &p, sizeof(*make)....

What's wrong with 

       struct kdbus_cmd_make *make = NULL;
       
       ret = kdbus_memdup_user(buf, &make, sizeof(*make) ... ????

Surely void pointers are a great guarantee to make things better,
right?

> +	case KDBUS_CMD_DOMAIN_MAKE: {
> +		const char *name;
> +
> +		if (!capable(CAP_IPC_OWNER)) {

Why is this not in the open() call? Because you have an opaque device
at the time of open()?

Offloading security relevant decisions to an ioctl is an interesting
design choice in theory. In fact it is just wrong.

> +			ret = -EPERM;
> +			break;
> +		}
> +
> +		ret = kdbus_memdup_user(buf, &p, sizeof(*make),
> +					KDBUS_MAKE_MAX_SIZE);
> +		if (ret < 0)
> +			break;
> +
> +		make = p;

See above.

> +/* kdbus endpoint make commands */
> +static long kdbus_handle_ioctl_ep(struct file *file, unsigned int cmd,
> +				  void __user *buf)
> +{
> +	struct kdbus_handle *handle = file->private_data;
> +	void *p = NULL;
> +	long ret = 0;
> +
> +	switch (cmd) {
> +	case KDBUS_CMD_ENDPOINT_MAKE: {
> +		struct kdbus_cmd_make *make;
> +		umode_t mode = 0;
> +		kgid_t gid = KGIDT_INIT(0);
> +		const char *name;
> +		struct kdbus_ep *ep;
> +
> +		/* creating custom endpoints is a privileged operation */
> +		if (!kdbus_bus_uid_is_privileged(handle->ep->bus)) {

See above.

> +			ret = -EPERM;
> +			break;
> +		}
> +
> +		ret = kdbus_memdup_user(buf, &p, sizeof(*make),
> +					KDBUS_MAKE_MAX_SIZE);
> +		if (ret < 0)
> +			break;
> +
> +		make = p;

See above.

> +	case KDBUS_CMD_HELLO: {
> +		struct kdbus_cmd_hello *hello;
> +		struct kdbus_conn *conn = NULL;
> +
> +		ret = kdbus_memdup_user(buf, &p, sizeof(*hello),
> +					KDBUS_HELLO_MAX_SIZE);
> +		if (ret < 0)
> +			break;
> +
> +		hello = p;

Ditto.

> +/* kdbus endpoint commands for connected peers */
> +static long kdbus_handle_ioctl_ep_connected(struct file *file, unsigned int cmd,
> +					    void __user *buf)
> +{
> +	struct kdbus_handle *handle = file->private_data;
> +	struct kdbus_conn *conn = handle->conn;
> +	void *p = NULL;
> +	long ret = 0;
> +
> +	/*
> +	 * BYEBYE is special; we must not acquire a connection when
> +	 * calling into kdbus_conn_disconnect() or we will deadlock,
> +	 * because kdbus_conn_disconnect() will wait for all acquired
> +	 * references to be dropped.
> +	 */
> +	if (cmd == KDBUS_CMD_BYEBYE) {
> +		if (!kdbus_conn_is_connected(conn))
> +			return -EOPNOTSUPP;

If the connection is down already then a BEYBEY is just moot. I don't
see a good reason WHY the return code is -EOPNOTSUPP.

Is this just to provide bug compability with the existing user space
code? If so, pick some proper return code which reflects the state and
deal with it in user space. If not, then you should think hard why you
did not find anything which is more appropriate in the wide choice of
error codes.

> +		return kdbus_conn_disconnect(conn, true);
> +	}
> +
> +	ret = kdbus_conn_acquire(conn);
> +	if (ret < 0)
> +		return ret;
> +
> +	switch (cmd) {
> +	case KDBUS_CMD_NAME_ACQUIRE: {
> +		/* acquire a well-known name */
> +		struct kdbus_cmd_name *cmd_name;
> +
> +		if (!kdbus_conn_is_connected(conn)) {
> +			ret = -EOPNOTSUPP;

See above.

> +			break;
> +		}

Aside of that what makes sure that the connection is not going away
after you checked it above?

Magic serialization or what? I can't see any of it.

If it's just an optimization then it wants to have a proper comment
and not just a random chosen return code which matches the expectation
of some equally undocumented user space app.

> +static long kdbus_handle_ioctl(struct file *file, unsigned int cmd,
> +			       unsigned long arg)
> +{
> +	struct kdbus_handle *handle = file->private_data;
> +	void __user *argp = (void __user *)arg;
> +	enum kdbus_handle_type type = handle->type;
> +
> +	/* make sure all handle fields are set if handle->type is */
> +	smp_rmb();

Sure. You really need this kind of serialization because your design
choice of allowing opaque handles in the first place.

I'm really interested why you need this rmb() at all. Just because you
have several threads in user space which might race with the type
assignment when they call the ioctl?

We have a strict requirement to document memory barriers. The
following comment definitely does not fulfil this requirement as it
just documents that someone observed a race of unknown provenance and
got it 'fixed' with a 'smp_rmb()'

> +     /* make sure all handle fields are set if handle->type is */

That's really hillarious, The user space side knows excatly upfront
which type of 'handle' it wants to open. Making it an opaque handle in
the first place and let the kernel deal with the actual type
assignment is beyond silly. Especially if that involves undocumented
memory barriers.

> +	switch (type) {
> +	case KDBUS_HANDLE_CONTROL:
> +		return kdbus_handle_ioctl_control(file, cmd, argp);
> +
> +	case KDBUS_HANDLE_EP:
> +		return kdbus_handle_ioctl_ep(file, cmd, argp);
> +
> +	case KDBUS_HANDLE_ENDPOINT_CONNECTED:
> +		return kdbus_handle_ioctl_ep_connected(file, cmd, argp);
> +
> +	case KDBUS_HANDLE_ENDPOINT_OWNER:
> +		return kdbus_handle_ioctl_ep_owner(file, cmd, argp);
> +
> +	default:
> +		return -EBADFD;
> +	}
> +}
> +
> +static unsigned int kdbus_handle_poll(struct file *file,
> +				      struct poll_table_struct *wait)
> +{
> +	struct kdbus_handle *handle = file->private_data;
> +	struct kdbus_conn *conn;
> +	unsigned int mask = POLLOUT | POLLWRNORM;
> +
> +	/* Only a connected endpoint can read/write data */
> +	if (handle->type != KDBUS_HANDLE_ENDPOINT_CONNECTED)
> +		return POLLERR | POLLHUP;
> +
> +	/* make sure handle->conn is set if handle->type is */
> +	smp_rmb();

Surely we need to plaster that all over the place just because we
avoid to open dedicated devices in the first place. And do not tell me
that the open call does not know what type it is going to be.

Copying badly designed userspace code to the kernel without rethinking
the design and 'fixing' the short comings by copying the same 'fixup'
over and over is definitely a guarantee for interesting CVEs in the
future.

Thanks,

	tglx
