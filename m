From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/6] security: Add hooks to rule on setting a superblock
 or mount watch [ver #5]
Date: Sat, 13 Jul 2019 06:11:39 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1907130611040.4685@namei.org>
References: <156173701358.15650.8735203424342507015.stgit@warthog.procyon.org.uk> <156173702349.15650.1484210092464492434.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156173702349.15650.1484210092464492434.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 28 Jun 2019, David Howells wrote:

> Add security hooks that will allow an LSM to rule on whether or not a watch
> may be set on a mount or on a superblock.  More than one hook is required
> as the watches watch different types of object.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Casey Schaufler <casey@schaufler-ca.com>
> cc: Stephen Smalley <sds@tycho.nsa.gov>
> cc: linux-security-module@vger.kernel.org
> ---
> 
>  include/linux/lsm_hooks.h |   16 ++++++++++++++++
>  include/linux/security.h  |   10 ++++++++++
>  security/security.c       |   10 ++++++++++
>  3 files changed, 36 insertions(+)


Acked-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>
