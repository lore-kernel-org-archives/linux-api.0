From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] fs: check for DAC_READ_SEARCH instead of SYS_ADMIN
Date: Sun, 22 Oct 2017 01:25:36 -0400
Message-ID: <20171022052536.ptxvnyafk25pakrk@thunk.org>
References: <20171021132446.17567-1-nicolas@belouin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171021132446.17567-1-nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 21, 2017 at 03:24:46PM +0200, Nicolas Belouin wrote:
> These checks are meant to prevent leaks or attacks via directory
> traversal, the use of CAP_SYS_ADMIN here is a misuse,
> CAP_DAC_READ_SEARCH being way more appropriate as a process
> with CAP_DAC_READ_SEARCH is entrusted with going trough all directories.
> CAP_SYS_ADMIN is not meant to flag such a process.
> 
> Signed-off-by: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>

No.  lookup_dcookie() is a horrid, horrid, hack which is
*spectacularly* dangerous.  We should not be trying to encourage its
use for anything beside its single legacy user, oprofile(8), for which
CAP_SYS_ADMIN is appropriate.

						- Ted
