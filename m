From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/8] uuid: convert users to generic UUID API
Date: Mon, 4 Apr 2016 16:40:20 -0700
Message-ID: <20160404164020.9a3529e6e247aac6ec114fff@linux-foundation.org>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>, Matt Fleming <matt@codeblueprint.co.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon,  4 Apr 2016 16:30:02 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> There are few functions here and there along with type definitions that provide
> UUID API. This series consolidates everything under one hood and converts
> current users.

Well.  It converts two current users.

There are many references to "uuid" in the tree.  How many sites could
potentially benefit from this change?

> This has been tested for a while internally, however it doesn't mean we covered
> all possible cases (especially accuracy of UUID constants after conversion).
> So, please test this as much as you can and provide your tag. We appreciate the
> effort.

I'm not sure who this series was aimed at but I saw "lib" and grabbed
it.  I'll await Matt's ack.
