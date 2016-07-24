From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 1/5] namespaces: move user_ns into ns_common
Date: Sun, 24 Jul 2016 00:00:13 -0500
Message-ID: <87k2gbmy02.fsf@x220.int.ebiederm.org>
References: <CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
	<1468548742-32136-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468548742-32136-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> (Andrey
	Vagin's message of "Thu, 14 Jul 2016 19:12:18 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:

> Every namespace has a pointer to an user namespace where is was created,
> but they're all privately embedded in the individual namespace specific
> structures.
>
> Now we are going to add an user-space interface to get an owning user
> namespace, so it looks reasonable to move it into ns_common.
>
> Originally this idea was suggested by James Bottomley.

I skimmed through this and I really don't like move user_ns into
ns_common.  If for no other reason that it seems to have guarantteed
this patchset as written would not apply to my tree.

> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 8297e5b..a941b44 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -27,11 +27,15 @@ struct user_namespace {
>  	struct uid_gid_map	gid_map;
>  	struct uid_gid_map	projid_map;
>  	atomic_t		count;
> -	struct user_namespace	*parent;
>  	int			level;
>  	kuid_t			owner;
>  	kgid_t			group;
> -	struct ns_common	ns;
> +
> +	/* ->ns.user_ns and ->parent are synonyms */
> +	union {
> +		struct user_namespace	*parent;
> +		struct ns_common	ns;
> +	};
>  	unsigned long		flags;
>  
>  	/* Register of per-UID persistent keyrings for this namespace */

This union is unmaintainable.  It is very easy for someone to change
ns_common and accidentially break this.  The C standard does not
allow data to be accessed as either one union member or the other.
Which means semantically this code relies on undefined behavior, and
the compiler can do anything in this case and gcc has sometimes been
known to use that allowance.

Eric
