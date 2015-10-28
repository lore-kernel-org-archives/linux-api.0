From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v4] serial: support 16-bit register interface for console
Date: Wed, 28 Oct 2015 09:51:12 -0400
Message-ID: <5630D2D0.1080303@hurleysoftware.com>
References: <1446003965-11457-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1446003965-11457-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-doc-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-serial@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On 10/27/2015 11:46 PM, Masahiro Yamada wrote:
> Currently, 8-bit (MMIO) and 32-bit (MMIO32) register interfaces are
> supported for the 8250 console, but the 16-bit (MMIO16) is not.
> The 8250 UART device on my board is connected to a 16-bit bus and
> my main motivation is to use earlycon with it.
> (Refer to arch/arm/boot/dts/uniphier-support-card.dtsi)

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

