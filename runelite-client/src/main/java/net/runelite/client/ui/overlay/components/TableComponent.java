/*
 * Copyright (c) 2018, Tomas Slusny <slusnucky@gmail.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package net.runelite.client.ui.overlay.components;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

/**
 * OpenOSRS compatible TableComponent for rendering tables in overlays
 */
public class TableComponent implements LayoutableRenderableEntity
{
	@Getter
	@Setter
	private final List<TableRow> rows = new ArrayList<>();

	@Getter
	@Setter
	private TableAlignment defaultAlignment = TableAlignment.LEFT;

	@Getter
	@Setter
	private Color defaultColor = Color.WHITE;

	@Getter
	@Setter
	private int gutter = 3;

	@Getter
	@Setter
	private Rectangle bounds = new Rectangle();

	@Getter
	@Setter
	private Point preferredLocation = new Point();

	@Getter
	@Setter
	private Dimension preferredSize = new Dimension();

	public void addRow(TableRow row)
	{
		rows.add(row);
	}

	public void addRows(TableRow... rows)
	{
		for (TableRow row : rows)
		{
			this.rows.add(row);
		}
	}

	public void setColumnAlignments(TableAlignment... alignments)
	{
		for (int i = 0; i < rows.size(); i++)
		{
			TableRow row = rows.get(i);
			List<TableElement> elements = row.getElements();
			
			for (int j = 0; j < elements.size() && j < alignments.length; j++)
			{
				elements.get(j).setAlignment(alignments[j]);
			}
		}
	}

	@Override
	public Dimension render(Graphics2D graphics)
	{
		if (rows.isEmpty())
		{
			return new Dimension();
		}

		final FontMetrics metrics = graphics.getFontMetrics();
		final int rowHeight = metrics.getHeight() + gutter;

		// Calculate column widths
		final int numColumns = getMaxColumns();
		final int[] columnWidths = new int[numColumns];

		for (TableRow row : rows)
		{
			List<TableElement> elements = row.getElements();
			for (int i = 0; i < elements.size(); i++)
			{
				TableElement element = elements.get(i);
				int width = metrics.stringWidth(element.getContent());
				columnWidths[i] = Math.max(columnWidths[i], width);
			}
		}

		// Calculate total width
		int totalWidth = 0;
		for (int width : columnWidths)
		{
			totalWidth += width + gutter;
		}
		totalWidth = Math.max(0, totalWidth - gutter);

		// Render rows
		int y = 0;
		for (TableRow row : rows)
		{
			int x = 0;
			List<TableElement> elements = row.getElements();
			
			for (int i = 0; i < elements.size(); i++)
			{
				TableElement element = elements.get(i);
				Color color = element.getColor() != null ? element.getColor() : defaultColor;
				TableAlignment alignment = element.getAlignment() != null ? element.getAlignment() : defaultAlignment;

				graphics.setColor(color);
				
				int textX = x;
				if (alignment == TableAlignment.CENTER)
				{
					textX = x + (columnWidths[i] - metrics.stringWidth(element.getContent())) / 2;
				}
				else if (alignment == TableAlignment.RIGHT)
				{
					textX = x + columnWidths[i] - metrics.stringWidth(element.getContent());
				}

				graphics.drawString(element.getContent(), textX, y + metrics.getAscent());
				x += columnWidths[i] + gutter;
			}
			y += rowHeight;
		}

		return new Dimension(totalWidth, y);
	}

	private int getMaxColumns()
	{
		int maxColumns = 0;
		for (TableRow row : rows)
		{
			maxColumns = Math.max(maxColumns, row.getElements().size());
		}
		return maxColumns;
	}

	/**
	 * Alignment options for table elements
	 */
	public enum TableAlignment
	{
		LEFT,
		CENTER, 
		RIGHT
	}
}
