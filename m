From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Wed, 29 Oct 2014 20:59:44 -0700
Message-ID: <8738a6w6kv.fsf@x220.int.ebiederm.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414620056-6675-9-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
	(Greg Kroah-Hartman's message of "Wed, 29 Oct 2014 15:00:52 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> writes:

The way capabilities are checked in this patch make me very nervous.

We are not checking permissions at open time.  Every other location
of calling capable on file like objects has been show to be suceptible
to file descriptor pass attacks.

> See Documentation/kdbus.txt for more details.
>
> Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> ---

> diff --git a/drivers/misc/kdbus/bus.c b/drivers/misc/kdbus/bus.c
> new file mode 100644
> index 000000000000..6dcaf22f5d59
> --- /dev/null
> +++ b/drivers/misc/kdbus/bus.c
> @@ -0,0 +1,450 @@

> +/**
> + * kdbus_bus_cred_is_privileged() - check whether the given credentials in
> + *				    combination with the capabilities of the
> + *				    current thead are privileged on the bus
> + * @bus:		The bus to check
> + * @cred:		The credentials to match
> + *
> + * Return: true if the credentials are privileged, otherwise false.
> + */
> +bool kdbus_bus_cred_is_privileged(const struct kdbus_bus *bus,
> +				  const struct cred *cred)
> +{
> +	/* Capabilities are *ALWAYS* tested against the current thread, they're
> +	 * never remembered from conn-credentials. */
> +	if (ns_capable(&init_user_ns, CAP_IPC_OWNER))
> +		return true;
> +
> +	return uid_eq(bus->uid_owner, cred->fsuid);
> +}
> +
> +/**
> + * kdbus_bus_uid_is_privileged() - check whether the current user is a
> + *				   priviledged bus user
> + * @bus:		The bus to check
> + *
> + * Return: true if the current user has CAP_IPC_OWNER capabilities, or
> + * if it has the same UID as the user that created the bus. Otherwise,
> + * false is returned.
> + */
> +bool kdbus_bus_uid_is_privileged(const struct kdbus_bus *bus)
> +{
> +	return kdbus_bus_cred_is_privileged(bus, current_cred());
> +}


> +/**
> + * kdbus_bus_new() - create a new bus
> + * @domain:		The domain to work on
> + * @make:		Pointer to a struct kdbus_cmd_make containing the
> + *			details for the bus creation
> + * @name:		Name of the bus
> + * @bloom:		Bloom parameters for this bus
> + * @mode:		The access mode for the device node
> + * @uid:		The uid of the device node
> + * @gid:		The gid of the device node
> + * @bus:		Pointer to a reference where the new bus is stored
> + *
> + * This function will allocate a new kdbus_bus and link it to the given
> + * domain.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int kdbus_bus_new(struct kdbus_domain *domain,
> +		  const struct kdbus_cmd_make *make,
> +		  const char *name,
> +		  const struct kdbus_bloom_parameter *bloom,
> +		  umode_t mode, kuid_t uid, kgid_t gid,
> +		  struct kdbus_bus **bus)
> +{
[snip]
> +
> +	if (!capable(CAP_IPC_OWNER) &&
> +	    atomic_inc_return(&b->user->buses) > KDBUS_USER_MAX_BUSES) {
> +		atomic_dec(&b->user->buses);
> +		ret = -EMFILE;
> +		goto exit_unref_user_unlock;
> +	}
> +
