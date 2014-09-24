From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 2/3] tools: adding clean target to user selftest
Date: Wed, 24 Sep 2014 11:20:49 -0600
Message-ID: <5422FD71.3020603@osg.samsung.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com> <1411502120-28219-1-git-send-email-pfeiner@google.com> <1411502120-28219-3-git-send-email-pfeiner@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411502120-28219-3-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Feiner <pfeiner@google.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>, Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 09/23/2014 01:55 PM, Peter Feiner wrote:
> Gets rid of this error when running 'make clean' in the selftests
> directory:
> 
> make[1]: Entering directory `.../tools/testing/selftests/user'
> make[1]: *** No rule to make target `clean'.  Stop.
> 

Signed-off is missing. Please make sure patches have
your Signed-off

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
