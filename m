From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V32 01/27] Add the ability to lock down access to the
 running kernel image
Date: Mon, 29 Apr 2019 15:56:44 -0700
Message-ID: <CACdnJus-+VTy0uOWg982SgZr55Lp7Xot653dJb_tO5T=J6D8nw@mail.gmail.com>
References: <20190404003249.14356-1-matthewgarrett@google.com> <20190404003249.14356-2-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404003249.14356-2-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

Hi James,

What's the best way forward with this? I'm still not entirely clear on
how it can be implemented purely as an LSM, but if you have ideas on
what sort of implementation you'd prefer I'm happy to work on that.
