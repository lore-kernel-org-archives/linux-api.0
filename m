From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: Re: [RFC v10][PATCH 09/13] Restore open file descriprtors
Date: Mon, 01 Dec 2008 16:00:54 -0500
Message-ID: <49345086.4@cs.columbia.edu>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>	 <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>	 <20081128112745.GR28946@ZenIV.linux.org.uk>	 <1228159324.2971.74.camel@nimitz>  <49344C11.6090204@cs.columbia.edu> <1228164873.2971.95.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1228164873.2971.95.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org



Dave Hansen wrote:
> On Mon, 2008-12-01 at 15:41 -0500, Oren Laadan wrote:
>>>>> +   fd = cr_attach_file(file);      /* no need to cleanup 'file' below */
>>>>> +   if (fd < 0) {
>>>>> +           filp_close(file, NULL);
>>>>> +           ret = fd;
>>>>> +           goto out;
>>>>> +   }
>>>>> +
>>>>> +   /* register new <objref, file> tuple in hash table */
>>>>> +   ret = cr_obj_add_ref(ctx, file, parent, CR_OBJ_FILE, 0);
>>>>> +   if (ret < 0)
>>>>> +           goto out;
>>>> Who said that file still exists at that point?
>> Correct. This call should move higher up befor ethe call to cr_attach_file()
> 
> Is that sufficient?  It seems like we're depending on the fd's reference
> to the 'struct file' to keep it valid in the hash.  If something happens
> to the fd (like the other thread messing with it) the 'struct file' can
> still go away.
> 
> Shouldn't we do another get_file() for the hash's reference?

When a shared object is inserted to the hash we automatically take another
reference to it (according to its type) for as long as it remains in the
hash. See:  'cr_obj_ref_grab()' and 'cr_obj_ref_drop()'.  So by moving that
call higher up, we protect the struct file.

Oren.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
