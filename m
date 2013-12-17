From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 2/3] statxat: Add a system call to make extended file
 stats available
Date: Tue, 17 Dec 2013 11:20:14 +0100
Message-ID: <52B0255E.6040503@redhat.com>
References: <20131112173518.25813.67568.stgit@warthog.procyon.org.uk> <20131112173534.25813.70732.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-45813-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-##L=##H@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20131112173534.25813.70732.stgit@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>, viro@ZenIV.linux.org.uk
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, andreas.gruenbacher@gmail.com, samba-technical@lists.samba.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/12/2013 06:35 PM, David Howells wrote:
> 		uint64_t	st_ino;
> 		uint64_t	st_size;
> 		uint64_t	st_blocks;

Should this include zeroed fields for 128 bit forward compatibility?

Windows SIDs would be expressed as extended attributes and therefore are 
not needed to be presented here, correct?  What about the presence of 
alternate data streams/resource forks?

-- 
Florian Weimer / Red Hat Product Security Team
