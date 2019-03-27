From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V31 25/25] debugfs: Disable open() when kernel is locked
 down
Date: Wed, 27 Mar 2019 09:31:30 +0900
Message-ID: <20190327003130.GB27311@kroah.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-26-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190326182742.16950-26-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 11:27:41AM -0700, Matthew Garrett wrote:
> From: Matthew Garrett <mjg59@google.com>
> 
> debugfs has not been meaningfully audited in terms of ensuring that
> userland cannot trample over the kernel. At Greg's request, disable
> access to it entirely when the kernel is locked down. This is done at
> open() time rather than init time as the kernel lockdown status may be
> made stricter at runtime.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Cc: gregkh@linuxfoundation.org
> ---
>  fs/debugfs/file.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 4fce1da7db23..9ae12ef29ba0 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -142,6 +142,9 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
>  	const struct file_operations *real_fops = NULL;
>  	int r;
>  
> +	if (kernel_is_locked_down("debugfs", LOCKDOWN_INTEGRITY))
> +		return -EPERM;

Why allow all this, why not just abort the registering of the filesystem
with the vfs core so it can't even be mounted?

thanks,

greg k-h
