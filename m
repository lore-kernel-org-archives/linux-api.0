From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [char-misc-next 04/11 V2] uuid: extract macros for assigning raw
 arrays
Date: Wed, 27 May 2015 16:14:20 -0700
Message-ID: <20150527231420.GA29446@kroah.com>
References: <1432741333-11889-1-git-send-email-tomas.winkler@intel.com>
 <20150527165054.GB3533@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B3C4A2C8C@hasmsx109.ger.corp.intel.com>
 <20150527172919.GA5525@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B3C4A2CDF@hasmsx109.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B3C4A2CDF-Jy8z56yoSI/jxeytcECX8bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2015 at 05:42:22PM +0000, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> > Sent: Wednesday, May 27, 2015 20:29
> > To: Winkler, Tomas
> > Cc: arnd-r2nGTMty4D4@public.gmane.org; Stephen Rothwell; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [char-misc-next 04/11 V2] uuid: extract macros for assigning raw
> > arrays
> > 
> > On Wed, May 27, 2015 at 05:24:01PM +0000, Winkler, Tomas wrote:
> > >
> > > >
> > > > On Wed, May 27, 2015 at 06:42:13PM +0300, Tomas Winkler wrote:
> > > > > In order for mei client devices to use device id based on uuid we
> > > > > have to use common types between user space (file2alias.c).
> > > > > Similarly to vmbus,  mei  uses raw 16 byte array for that.
> > > > > To leverage on existing infrastructure around uuid_le type
> > > > > defined in uuid.h we add helper macros to handle conversions between
> > > > > raw 16 byte array and uuid_{le,be} types.
> > > >
> > > > You aren't adding a helper macro, you are just redefining the existing
> > > > macros using a different one.
> > >
> > > Not exactly I'm using both the one I've added for device ids and the old one for
> > all the other flows.
> > >
> > >  But I can't see why this is needed, what
> > > > does this solve that vmbus and other uses of the existing macros don't
> > > > need?  In other words, what makes mei so special that it needs a "lower"
> > > > level macro than every other subsystem?
> > >
> > > It's not special there is actually a lot of code duplication around uuid handling
> > > every subsystem is using their own macros but it can be consolidated around
> > uuid.h
> > >
> > > So vmbus can use that
> > > Instead of
> > > /*
> > >  * Network GUID
> > >  * {f8615163-df3e-46c5-913f-f2d2f965ed0e}
> > >  */
> > > #define HV_NIC_GUID \
> > >         .guid = { \
> > >                         0x63, 0x51, 0x61, 0xf8, 0x3e, 0xdf, 0xc5, 0x46, \
> > >                         0x91, 0x3f, 0xf2, 0xd2, 0xf9, 0x65, 0xed, 0x0e \
> > >                 }
> > >
> > > The can use the new macro to make it more readable, something in spirit of:
> > >
> > > #define HV_NIC_GUID __UUID_LE(f8615163-df3e-46c5-913f-f2d2f965ed0e)
> > 
> > Why the "__" usage here?  That signifies a "private" namespace, why add
> > that to the user visible header files?
> 
> I take any other suggestion for macro names.  
> Not sure how I would reuse the macros if I don't export them both,
> second this can be used also by user space.  

But it's not needed at all.

Below is a patch on top of my current tree that makes this patch not
needed.  Any objection to me just applying it instead?

> > And are you going to send patches for vmbus and other drivers to fix
> > everything up to use these new macros?  Someone has to...
> 
> Can be done but I cannot test their code and  now I'm busy with splitting the big bus patch :)

Ok, that means no one is ever going to do that work, so it's not a valid
reason to accept such a change.  I prefer the patch below.

thanks,

greg k-h

diff --git a/drivers/nfc/mei_phy.h b/drivers/nfc/mei_phy.h
index a51f8f2685cc..fbfa3e61738f 100644
--- a/drivers/nfc/mei_phy.h
+++ b/drivers/nfc/mei_phy.h
@@ -5,7 +5,7 @@
 #include <net/nfc/hci.h>
 #include <linux/uuid.h>
 
-#define MEI_NFC_UUID __UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, \
+#define MEI_NFC_UUID UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, \
 		0x94, 0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
 #define MEI_NFC_HEADER_SIZE 10
 #define MEI_NFC_MAX_HCI_PAYLOAD 300
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 2d2b2b571d61..048c270822f9 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -614,7 +614,7 @@ struct ipack_device_id {
  */
 struct mei_cl_device_id {
 	char name[MEI_CL_NAME_SIZE];
-	__u8 uuid[16];
+	uuid_le uuid;
 	kernel_ulong_t driver_info;
 };
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 62c517f4b592..718b2a29bd43 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -34,6 +34,9 @@ typedef Elf64_Addr	kernel_ulong_t;
 typedef uint32_t	__u32;
 typedef uint16_t	__u16;
 typedef unsigned char	__u8;
+typedef struct {
+	__u8 b[16];
+} uuid_le;
 
 /* Big exception to the "don't include kernel headers into userspace, which
  * even potentially has different endianness and word sizes, since
@@ -131,13 +134,13 @@ static inline void add_wildcard(char *str)
 		strcat(str + len, "*");
 }
 
-static inline void add_uuid(char *str, __u8 uuid[16])
+static inline void add_uuid(char *str, uuid_le uuid)
 {
 	int len = strlen(str);
 	int i;
 
 	for (i = 0; i < 16; i++)
-		sprintf(str + len + (i << 1), "%02x", uuid[i]);
+		sprintf(str + len + (i << 1), "%02x", uuid.b[i]);
 }
 
 /**
