From: Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Thu, 30 Oct 2014 10:58:54 +0100
Message-ID: <20141030095854.GA4716@dztty>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <8738a6w6kv.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8738a6w6kv.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com, simon.mcvittie@collabora.co.uk, daniel@zonque.org, alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk, teg@jklm.no, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 08:59:44PM -0700, Eric W. Biederman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> The way capabilities are checked in this patch make me very nervous.
> 
> We are not checking permissions at open time.  Every other location
> of calling capable on file like objects has been show to be suceptible
> to file descriptor pass attacks.
Yes, I do understand the concern, this is valid for some cases! but we
can't apply it on the ioctl API ?! please see below:

All (perhaps not all) the current ioctl do not check for fd passing
attacks! if a privileged do arbitrary ioctl on untrusted fds we are
already owned... the dumb privileged process is the one to blame, right?


Example:
1) fs/ext4/ioctl.c:ext4_ioctl()
   they have:
   inode_owner_or_capable() + capable() checks

   for all the restricted ioctl()

2) fs/xfs/xfs_ioctl.c:xfs_file_ioctl()
   they have:
   capable() checks

3) fs/btrfs/ioctl.c:btrfs_ioctl()
   they have capable() + inode_owner_or_capable()

... long list

These are sensible API and they do not care at all about fd passing,
so I don't think we should care either ?! or perhaps I'm missing
something ?


The capable() is done as it is, and for the inode_owner_or_capable() you
will notice that we followed the same logic and did use it in our
kdbus_bus_uid_is_privileged() to stay safe and follow what other API are
doing.

Thank you for the comments!


> > See Documentation/kdbus.txt for more details.
> >
> > Signed-off-by: Daniel Mack <daniel@zonque.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> 
> > diff --git a/drivers/misc/kdbus/bus.c b/drivers/misc/kdbus/bus.c
> > new file mode 100644
> > index 000000000000..6dcaf22f5d59
> > --- /dev/null
> > +++ b/drivers/misc/kdbus/bus.c
> > @@ -0,0 +1,450 @@
> 
> > +/**
> > + * kdbus_bus_cred_is_privileged() - check whether the given credentials in
> > + *				    combination with the capabilities of the
> > + *				    current thead are privileged on the bus
> > + * @bus:		The bus to check
> > + * @cred:		The credentials to match
> > + *
> > + * Return: true if the credentials are privileged, otherwise false.
> > + */
> > +bool kdbus_bus_cred_is_privileged(const struct kdbus_bus *bus,
> > +				  const struct cred *cred)
> > +{
> > +	/* Capabilities are *ALWAYS* tested against the current thread, they're
> > +	 * never remembered from conn-credentials. */
> > +	if (ns_capable(&init_user_ns, CAP_IPC_OWNER))
> > +		return true;
> > +
> > +	return uid_eq(bus->uid_owner, cred->fsuid);
> > +}
> > +
> > +/**
> > + * kdbus_bus_uid_is_privileged() - check whether the current user is a
> > + *				   priviledged bus user
> > + * @bus:		The bus to check
> > + *
> > + * Return: true if the current user has CAP_IPC_OWNER capabilities, or
> > + * if it has the same UID as the user that created the bus. Otherwise,
> > + * false is returned.
> > + */
> > +bool kdbus_bus_uid_is_privileged(const struct kdbus_bus *bus)
> > +{
> > +	return kdbus_bus_cred_is_privileged(bus, current_cred());
> > +}
> 
> 
> > +/**
> > + * kdbus_bus_new() - create a new bus
> > + * @domain:		The domain to work on
> > + * @make:		Pointer to a struct kdbus_cmd_make containing the
> > + *			details for the bus creation
> > + * @name:		Name of the bus
> > + * @bloom:		Bloom parameters for this bus
> > + * @mode:		The access mode for the device node
> > + * @uid:		The uid of the device node
> > + * @gid:		The gid of the device node
> > + * @bus:		Pointer to a reference where the new bus is stored
> > + *
> > + * This function will allocate a new kdbus_bus and link it to the given
> > + * domain.
> > + *
> > + * Return: 0 on success, negative errno on failure.
> > + */
> > +int kdbus_bus_new(struct kdbus_domain *domain,
> > +		  const struct kdbus_cmd_make *make,
> > +		  const char *name,
> > +		  const struct kdbus_bloom_parameter *bloom,
> > +		  umode_t mode, kuid_t uid, kgid_t gid,
> > +		  struct kdbus_bus **bus)
> > +{
> [snip]
> > +
> > +	if (!capable(CAP_IPC_OWNER) &&
> > +	    atomic_inc_return(&b->user->buses) > KDBUS_USER_MAX_BUSES) {
> > +		atomic_dec(&b->user->buses);
> > +		ret = -EMFILE;
> > +		goto exit_unref_user_unlock;
> > +	}
> > +

-- 
Djalal Harouni
http://opendz.org
