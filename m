From: "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: [PATCH 1/2] Define ENOAUTHSERVICE to indicate "Authentication
 service unavailable"
Date: Wed, 8 Feb 2012 15:48:51 +0000 (UTC)
Message-ID: <Pine.LNX.4.64.1202081546240.8820@digraph.polyomino.org.uk>
References: <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <libc-alpha-return-25090-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, keyrings@linux-nfs.org, linux-nfs@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Wed, 8 Feb 2012, David Howells wrote:

>  #define ERFKILL		132	/* Operation not possible due to RF-kill */
> +#define	ENOAUTHSERVICE	133	/* Authentication service not available */
>  
>  #define EHWPOISON	133	/* Memory page has hardware error */

Defining the new error to have the same value as EHWPOISON seems rather 
odd....

-- 
Joseph S. Myers
joseph@codesourcery.com
