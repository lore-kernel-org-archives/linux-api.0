From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 3/3] tools: parallel selftests building & running
Date: Tue, 23 Sep 2014 13:42:15 -0600
Message-ID: <5421CD17.7060302@osg.samsung.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com> <1411499123-18050-1-git-send-email-pfeiner@google.com> <1411499123-18050-3-git-send-email-pfeiner@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411499123-18050-3-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Feiner <pfeiner@google.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>, Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 09/23/2014 01:05 PM, Peter Feiner wrote:
> Now make -jN builds and runs selftests in parallel. Also, if one
> selftest fails to build or run, make will return an error, whereas
> before the error was ignored.
> 
> Also added missing clean target to user/Makefile so 'make clean' doesn't fail.
> 

Could you please split this into two patches. One for parallel
builds and the second for adding missing clean targets.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
