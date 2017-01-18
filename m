From: Michal Hocko <mhocko@kernel.org>
Subject: writev error codes
Date: Wed, 18 Jan 2017 16:44:31 +0100
Message-ID: <20170118154431.GD7021@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi,
we have noticed that one of the LTP tests started to fail after
99526912c934 ("fix iov_iter_fault_in_readable()"). The code has expected
EINVAL while it gets EFAULT. I believe the new behavior is reasonable,
but checking the man 2 writev, there is no mention about EFAULT,
and other errnos for that matter, so it seems this is rather under
documented and it can confuse users. LTP has been fixed in the meantime
[1] but this might come unexpected to others.

In principle writev as a write
"multiplier" should be allowed all the error codes that write(2) allows,
right? I am not sure how we should reflect that. Either c&p what we have
in man 2 write or put a reference to it and only describe writev
specific, if there are any (I haven't checked that).

[1] https://github.com/linux-test-project/ltp/commit/db19194527060a962955a7db54a2f5710e69bec9
-- 
Michal Hocko
SUSE Labs
