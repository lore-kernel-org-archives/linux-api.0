From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 3/5] test: firmware_class: add asynchronous request
 trigger
Date: Thu, 7 Jan 2016 13:56:22 -0700
Message-ID: <568ED0F6.5090701@osg.samsung.com>
References: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
 <1449701429-121423-3-git-send-email-computersforpeace@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449701429-121423-3-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Norris <computersforpeace@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ming Lei <ming.lei@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 12/09/2015 03:50 PM, Brian Norris wrote:
> We might want to test for bugs like that found in commit f9692b2699bd
> ("firmware: fix possible use after free on name on asynchronous
> request"), where the asynchronous request API had race conditions.
> 
> Let's add a simple file that will launch the async request, then wait
> until it's complete and report the status. It's not a true async test
> (we're using a mutex + wait_for_completion(), so we can't get more than
> one going at the same time), but it does help make sure the basic API is
> sane, and it can catch some class of bugs.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@suse.com>


Thanks for the patch. Applied to linux-kselftest next for 4.5-rc1.

thanks,
-- Shuah
-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
