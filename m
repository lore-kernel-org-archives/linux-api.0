From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V38 00/29] security: Add support for locking down the
 kernel
Date: Sat, 10 Aug 2019 16:08:42 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1908101608260.25186@namei.org>
References: <20190808000721.124691-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190808000721.124691-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 7 Aug 2019, Matthew Garrett wrote:

> Fixed an unused function parameter in patch 19, otherwise identical to
> V37.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next-lockdown
and next-testing
  
Please verify and test, as I had to make a few minor fixups for my v5.2   
base.


-- 
James Morris
<jmorris@namei.org>
