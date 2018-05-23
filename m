From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: semantics of rhashtable and sysvipc
Date: Wed, 23 May 2018 10:35:31 -0700
Message-ID: <20180523173531.q7qxm62dkw256nbk@linux-n805>
References: <20180523172500.anfvmjtumww65ief@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180523172500.anfvmjtumww65ief@linux-n805>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 23 May 2018, Davidlohr Bueso wrote:
>I see two possible fixes.

I guess a third option would be to make the hashtable static, but I'm not
against using rhashtables so I'm not really considering this.
