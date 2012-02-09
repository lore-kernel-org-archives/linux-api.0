From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] Define ENONAMESERVICE and ENAMEUNKNOWN to indicate name service errors
Date: Thu, 09 Feb 2012 10:04:49 +0000
Message-ID: <17614.1328781889@redhat.com>
References: <20120208141552.GA3273@umich.edu> <20120208122905.8902.65762.stgit@warthog.procyon.org.uk> <20120208122917.8902.78395.stgit@warthog.procyon.org.uk>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120208141552.GA3273-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Rees <rees-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

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

David
