From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V40 00/29] Add kernel lockdown functionality
Date: Mon, 19 Aug 2019 23:45:52 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.1908192345270.12391@namei.org>
References: <20190820001805.241928-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820001805.241928-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 19 Aug 2019, Matthew Garrett wrote:

> After chatting with James in person, I'm resending the full set with the
> fixes merged in in order to avoid any bisect issues. There should be no
> functional changes other than avoiding build failures with some configs,
> and fixing the oops in tracefs.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next-lockdown
and next-testing

Thanks!

-- 
James Morris
<jmorris@namei.org>
