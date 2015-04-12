From: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v12 1/5] vfs: adds general codes to enforces project quota limits
Date: Sun, 12 Apr 2015 15:49:11 +0200
Message-ID: <CAMXgnP7wohyiMOAVR6B5H8r3hYBCo0Cz3ofzG_AzRnjWytbYOA@mail.gmail.com>
References: <1428592477-8212-1-git-send-email-lixi@ddn.com>
	<1428592477-8212-2-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428592477-8212-2-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 9 April 2015 at 17:14, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This patch adds support for a new quota type PRJQUOTA for project quota
> enforcement. Also a new method get_projid() is added into dquot_operations
> structure.
>(...)
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 2aa4151..33b30b1 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -30,7 +30,10 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
>         case Q_XGETQSTATV:
>         case Q_XQUOTASYNC:
>                 break;
> -       /* allow to query information for dquots we "own" */
> +       /*
> +        * allow to query information for dquots we "own"
> +        * always allow querying project quota
> +        */

I would add a precision in the comment:

always allow querying project quota when the project id is mapped in
the current user namespace.

id is the id in the current user namespace. So quotas for unmapped
users, unmapped groups or unmapped projects cannot be queried.
