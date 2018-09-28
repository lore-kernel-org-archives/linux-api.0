From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-core] [PATCH 07/11] UAPI: netfilter: Fix symbol
 collision issues [ver #2]
Date: Fri, 28 Sep 2018 15:07:04 +0200
Message-ID: <20180928130704.kcmsnsecp6aqpk66@salvia>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
 <153622555128.14298.11612304975343930534.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153622555128.14298.11612304975343930534.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, coreteam@netfilter.org, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 06, 2018 at 10:19:11AM +0100, David Howells wrote:
> The netfilter UAPI headers have some symbol collision issues:
> 
>  (1) "enum nfnl_acct_msg_types" is defined twice, and each definition is
>      completely different.
> 
>      Fix this by renaming the one in nfnetlink_cthelper.h to be "enum
>      nfnl_cthelper_types" to be consistent with the other things in that
>      file.
> 
>  (2) There's a disagreement between ipt_ECN.h and ipt_ecn.h over the
>      definition of various IPT_ECN_* constants, leading to an error over
>      IPT_ECN_IP_MASK being substituted when being defined as an enum value
>      in ipt_ecn.h if ipt_ECN.h is #included first.
> 
>      Fix this by removing the conflicting constants from ipt_ECN.h and
>      including ipt_ecn.h instead.

David, may I upstream this or you will pass it to Greg? I can just
take this, as you prefer.

Thanks.
