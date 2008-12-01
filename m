From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v10][PATCH 09/13] Restore open file descriprtors
Date: Mon, 01 Dec 2008 13:07:31 -0800
Message-ID: <1228165651.2971.99.camel@nimitz>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>
	 <20081128112745.GR28946@ZenIV.linux.org.uk>
	 <1228159324.2971.74.camel@nimitz>  <49344C11.6090204@cs.columbia.edu>
	 <1228164873.2971.95.camel@nimitz>  <49345086.4@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49345086.4-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2008-12-01 at 16:00 -0500, Oren Laadan wrote:
> > Is that sufficient?  It seems like we're depending on the fd's reference
> > to the 'struct file' to keep it valid in the hash.  If something happens
> > to the fd (like the other thread messing with it) the 'struct file' can
> > still go away.
> > 
> > Shouldn't we do another get_file() for the hash's reference?
> 
> When a shared object is inserted to the hash we automatically take another
> reference to it (according to its type) for as long as it remains in the
> hash. See:  'cr_obj_ref_grab()' and 'cr_obj_ref_drop()'.  So by moving that
> call higher up, we protect the struct file.

That's kinda (and by kinda I mean really) disgusting.  Hiding that two
levels deep in what is effectively the hash table code where no one will
ever see it is really bad.  It also makes you lazy thinking that the
hash code will just know how to take references on whatever you give to
it.

I think cr_obj_ref_grab() is hideous obfuscation and needs to die.
Let's just do the get_file() directly, please.

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
