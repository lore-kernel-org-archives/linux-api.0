From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH V4 1/8] namespaces: assign each namespace instance a
	serial number
Date: Sat, 23 Aug 2014 07:05:35 -0500
Message-ID: <87ioljs968.fsf@x220.int.ebiederm.org>
References: <cover.1408581429.git.rgb@redhat.com>
	<cover.1408581429.git.rgb@redhat.com>
	<d5bfd81a219c5c45c910494d6a3478ce83052e1f.1408581429.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <d5bfd81a219c5c45c910494d6a3478ce83052e1f.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	(Richard Guy Briggs's message of "Wed, 20 Aug 2014 21:09:34 -0400")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Generate and assign a serial number per namespace instance since boot.
>
> Use a serial number per namespace (unique across one boot of one kernel)
> instead of the inode number (which is claimed to have had the right to change
> reserved and is not necessarily unique if there is more than one proc fs) to
> uniquely identify it per kernel boot.

This approach is just broken.

For this to work with migration (aka criu) you need to implement a
namespace of namespaces.  You haven't done this, and therefore
such an interface will break existing userspace.

Inside of audit I can understand not caring about these issues,
but you go foward and expose these serial numbers in proc,
and generally make this infrastructure available to others.

The deep issue with migration is that we move tasks from one machine
from another and on the destination machine we need to have all of the
same global identifiers for software to function properly.

My weasel words around the proc inode numbers is to preserve to allow us
room to be able to restore those ids if it every becomes relevant for
migration.

That is the proc inode numbers (technically) live in a pid namespace,
(aka a mount of proc).  So depending on the pid namespace you are in
or the mount of proc you look in the numbers could change.

Qualifications like that must exist to have a prayer of ever supporting
process migration in the crazy corner cases where people start caring
about inode numbers.

We currently don't and inode numbers for a namespace will never change
after a namespace is created.  So I think you really are ok using the
proc inode numbers.  I am happy declaring by fiat that the inode numbers
that audit uses are the numbers connected to the initial pid namespace.

At a fairly basic level anything that is used to identify namespaces for
any general purpose use needs to have most if not all of the same
properties of the proc inode numbers.  The most important of which is
being tied to some context/namespace so there is a ability if we ever
need it to migrate those numbers from one machine to another.

Eric

> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 8e78110..93cb380 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -41,6 +41,23 @@ struct nsproxy init_nsproxy = {
>  #endif
>  };
>  
> +/**
> + * ns_serial - compute a serial number for the namespace
> + *
> + * Compute a serial number for the namespace to uniquely identify it in
> + * audit records.
> + */
> +long long ns_serial(void)
> +{
> +	static atomic64_t serial = ATOMIC_INIT(4); /* reserved for IPC, UTS, user, PID */
> +	long long ret;
> +
> +	ret = atomic64_add_return(1, &serial);
> +	BUG_ON(!ret);
> +
> +	return ret;
> +}
> +
>  static inline struct nsproxy *create_nsproxy(void)
>  {
>  	struct nsproxy *nsproxy;
