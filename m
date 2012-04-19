From: Paul Eggert <eggert@cs.ucla.edu>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 19 Apr 2012 14:51:18 -0700
Message-ID: <4F9088D6.9020203@cs.ucla.edu>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <20120419163238.61D382C0DF@topped-with-meat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-27653-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <20120419163238.61D382C0DF@topped-with-meat.com>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Roland McGrath <roland@hack.frob.com>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On 04/19/2012 09:32 AM, Roland McGrath wrote:
> I have no comment on the functionality.  But "xstat" is probably a poor
> choice of name. 

In AIX 7.1 the (similar) function is called statxat instead of xstat.
The API isn't exactly the same, but it's the same basic idea.
Might be worth looking at, not merely to see whether the API
should be the same, but also to borrow good ideas even if not.

http://pic.dhe.ibm.com/infocenter/aix/v7r1/topic/com.ibm.aix.basetechref/doc/basetrf2/statx.htm
