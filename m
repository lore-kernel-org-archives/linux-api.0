From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] kobject: export kset_find_obj() to be used from
 modules
Date: Mon, 10 Aug 2015 11:33:04 -0700
Message-ID: <20150810183304.GC18817@kroah.com>
References: <cover.1439220623.git.somlo@cmu.edu>
 <5c2bafb073e1386e39c4f73a83e7d835547b6b1f.1439220623.git.somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5c2bafb073e1386e39c4f73a83e7d835547b6b1f.1439220623.git.somlo@cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: ralf@linux-mips.org, zajec5@gmail.com, paul@pwsan.com, galak@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, x86@kernel.org, linux-efi@vger.kernel.org, qemu-devel@nongnu.org, lersek@redhat.com, jordan.l.justen@intel.com, gleb@cloudius-systems.com, pbonzini@redhat.com, kraxel@redhat.com, eblake@redhat.com, rjones@redhat.com, kernelnewbies@kernelnewbies.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 10, 2015 at 12:31:19PM -0400, Gabriel L. Somlo wrote:
> From: "Gabriel Somlo" <somlo@cmu.edu>
> 
> Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
> ---
>  lib/kobject.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 3e3a5c3..f9754a0 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -1058,3 +1058,4 @@ EXPORT_SYMBOL(kobject_del);
>  
>  EXPORT_SYMBOL(kset_register);
>  EXPORT_SYMBOL(kset_unregister);
> +EXPORT_SYMBOL(kset_find_obj);

checkpatch doesn't like this for obvious reasons :)
