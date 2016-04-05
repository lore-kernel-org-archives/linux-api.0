From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 02/10] ima: use %pU to output UUID in printable format
Date: Tue, 05 Apr 2016 16:16:22 -0700
Message-ID: <1459898182.6715.22.camel@perches.com>
References: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1459864579-55988-3-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459864579-55988-3-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2016-04-05 at 16:56 +0300, Andy Shevchenko wrote:
> Instead of open coded variant re-use extension what vsprintf.c provid=
es us for
> ages.

trivia:

> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity=
/ima/ima_policy.c
[]
> @@ -1012,17 +1012,7 @@ int ima_policy_show(struct seq_file *m, void *=
v)
> =A0	}
> =A0
> =A0	if (entry->flags & IMA_FSUUID) {
> -		seq_puts(m, "fsuuid=3D");
> -		for (i =3D 0; i < ARRAY_SIZE(entry->fsuuid); ++i) {
> -			switch (i) {
> -			case 4:
> -			case 6:
> -			case 8:
> -			case 10:
> -				seq_puts(m, "-");
> -			}
> -			seq_printf(m, "%x", entry->fsuuid[i]);
> -		}
> +		seq_printf(m, "fsuuid=3D%pU", entry->fsuuid);
> =A0		seq_puts(m, " ");
> =A0	}

Maybe combine the printf and puts

		seq_printf(m,=A0"fsuuid=3D%pU ", entry->fsuuid);
