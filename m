From: Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 19 Apr 2012 09:32:38 -0700 (PDT)
Message-ID: <20120419163238.61D382C0DF@topped-with-meat.com>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-27635-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: David Howells's message of  Thursday, 19 April 2012 15:05:58 +0100 <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

I have no comment on the functionality.  But "xstat" is probably a poor
choice of name.  There is precedent for that function name with different
meaning in the userland APIs.  (It's a moderately useless meaning inherited
from SVR4, but regardless overloading a name previously used is unwise.)


Thanks,
Roland
