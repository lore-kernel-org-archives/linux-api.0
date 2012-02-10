From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] Define ENONAMESERVICE and ENAMEUNKNOWN to indicate name service errors
Date: Fri, 10 Feb 2012 20:02:05 +0000
Message-ID: <25436.1328904125@redhat.com>
References: <20120209134429.GC6663@umich.edu> <20120208141552.GA3273@umich.edu> <20120208122905.8902.65762.stgit@warthog.procyon.org.uk> <20120208122917.8902.78395.stgit@warthog.procyon.org.uk> <17614.1328781889@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120209134429.GC6663-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:

>   > Would this be the same as NXDOMAIN?  That is, does it mean the name server
>   > couldn't find a record, or does it mean that the record doesn't exist?
>   
>   Is there a way to tell the difference?  Can you store a negative record in
>   the DNS?  Or is it that the DNS has records for the name, just not records
>   of the type you're looking for (eg. NO_ADDRESS/NO_DATA from
>   gethostbyname())?
> 
> It's an important distinction to the resolver if you want to avoid dns
> hijacking.  See rfc2308.  There doesn't seem to be a way to tell the
> difference from the gethostbyname call, which was designed before this was a
> problem.  The on-the-wire dns query protocol does make the distinction.
> 
> I suspect kernel dns clients won't need to know the difference, but I think
> it's useful if we decide on and document the meaning of the error codes.
> Maybe the answer is that ENAMEUNKNOWN means the same as a HOST_NOT_FOUND
> from gethostbyname().

Should I propose an extra error code?  Perhaps giving:

	ENONAMESERVICE	"Network name service unavailable"
	ENAMEUNKNOWN	"Network name not known"
	ENONAMERECORD	"Network name query returned no records"

Note that ENONAMESERVICE covers all of: not having a name service configured,
not being able to contact the configured name server and the configured name
server not being able to chain to the authoritative name server.  However, I
think this is probably okay.

David
