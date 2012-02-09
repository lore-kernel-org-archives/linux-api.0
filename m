From: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH 2/2] Define ENONAMESERVICE and ENAMEUNKNOWN to indicate
 name service errors
Date: Thu, 9 Feb 2012 08:44:29 -0500
Message-ID: <20120209134429.GC6663@umich.edu>
References: <20120208141552.GA3273@umich.edu>
 <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
 <20120208122917.8902.78395.stgit@warthog.procyon.org.uk>
 <17614.1328781889@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <17614.1328781889-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

David Howells wrote:

  Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:
  
  >   Define ENAMEUNKNOWN to indicate "Network name unknown".  This can be used to
  >   indicate, for example, that an attempt was made by dns_query() to make a query,
  >   but the name server (e.g. a DNS server) replied indicating that it had no
  >   matching records.
  > 
  > Would this be the same as NXDOMAIN?  That is, does it mean the name server
  > couldn't find a record, or does it mean that the record doesn't exist?
  
  Is there a way to tell the difference?  Can you store a negative record in the
  DNS?  Or is it that the DNS has records for the name, just not records of the
  type you're looking for (eg. NO_ADDRESS/NO_DATA from gethostbyname())?

It's an important distinction to the resolver if you want to avoid dns
hijacking.  See rfc2308.  There doesn't seem to be a way to tell the
difference from the gethostbyname call, which was designed before this was a
problem.  The on-the-wire dns query protocol does make the distinction.

I suspect kernel dns clients won't need to know the difference, but I think
it's useful if we decide on and document the meaning of the error codes.
Maybe the answer is that ENAMEUNKNOWN means the same as a HOST_NOT_FOUND
from gethostbyname().
