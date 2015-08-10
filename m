From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: Re: [PATCH 2/3] kobject: export kset_find_obj() to be
 used from modules
Date: Mon, 10 Aug 2015 14:43:10 -0400
Message-ID: <20150810184310.GM31816@HEDWIG.INI.CMU.EDU>
References: <cover.1439220623.git.somlo@cmu.edu>
	<5c2bafb073e1386e39c4f73a83e7d835547b6b1f.1439220623.git.somlo@cmu.edu>
	<20150810183304.GC18817@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20150810183304.GC18817@kroah.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: x86@kernel.org, paul@pwsan.com, matt.fleming@intel.com, gleb@cloudius-systems.com, jordan.l.justen@intel.com, rjones@redhat.com, linux-api@vger.kernel.org, zajec5@gmail.com, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, linux-efi@vger.kernel.org, kernelnewbies@kernelnewbies.org, kraxel@redhat.com, galak@codeaurora.org, pbonzini@redhat.com, lersek@redhat.com
List-Id: linux-api@vger.kernel.org

On Mon, Aug 10, 2015 at 11:33:04AM -0700, Greg KH wrote:
> On Mon, Aug 10, 2015 at 12:31:19PM -0400, Gabriel L. Somlo wrote:
> > From: "Gabriel Somlo" <somlo@cmu.edu>
> > 
> > Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
> > ---
> >  lib/kobject.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index 3e3a5c3..f9754a0 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -1058,3 +1058,4 @@ EXPORT_SYMBOL(kobject_del);
> >  
> >  EXPORT_SYMBOL(kset_register);
> >  EXPORT_SYMBOL(kset_unregister);
> > +EXPORT_SYMBOL(kset_find_obj);
> 
> checkpatch doesn't like this for obvious reasons :)

When I run checkpatch on this one, it comes back fine. Could you
please elaborate ?

[staging]$ scripts/checkpatch.pl
0002-kobject-export-kset_find_obj-to-be-used-from-modules.patch 
total: 0 errors, 0 warnings, 4 lines checked

0002-kobject-export-kset_find_obj-to-be-used-from-modules.patch has no
obvious style problems and is ready for submission.


Thanks much,
--Gabriel
